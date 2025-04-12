#!/bin/bash

WG_INTERFACE="wg0"
WG_DIR="/etc/wireguard"
CLIENTS_DIR="$WG_DIR/clients"
USED_IPS_FILE="$WG_DIR/used_ips.txt"
WG_CONFIG="$WG_DIR/$WG_INTERFACE.conf"
WG_PORT=51820
WG_SUBNET="10.10.0"
SERVER_IP="$WG_SUBNET.1"
CURRENT_DIR="$(pwd)"

function check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root (use sudo)"
        exit 1
    fi
}

function install_wireguard() {
    if ! command -v wg > /dev/null; then
        echo "[+] Installing WireGuard..."
        apt update && apt install -y wireguard
    fi
}

function init_server_config() {
    if [ ! -f "$WG_CONFIG" ]; then
        echo "[+] Initializing server config..."

        mkdir -p "$CLIENTS_DIR"
        touch "$USED_IPS_FILE"
        echo "$SERVER_IP" >> "$USED_IPS_FILE"

        umask 077
        wg genkey | tee "$WG_DIR/server_private.key" | wg pubkey > "$WG_DIR/server_public.key"

        cat > "$WG_CONFIG" <<EOF
[Interface]
Address = $SERVER_IP/24
ListenPort = $WG_PORT
PrivateKey = $(cat "$WG_DIR/server_private.key")
EOF

        systemctl enable "wg-quick@$WG_INTERFACE"
        systemctl start "wg-quick@$WG_INTERFACE"
    fi
}

function get_next_ip() {
    for i in {2..254}; do
        CANDIDATE="$WG_SUBNET.$i"
        grep -qx "$CANDIDATE" "$USED_IPS_FILE" || {
            echo "$CANDIDATE" >> "$USED_IPS_FILE"
            echo "$CANDIDATE"
            return
        }
    done
    echo "Error: No available IPs!" >&2
    exit 1
}

function add_client() {
    echo "Enter a name for the new client:"
    read -r CLIENT_NAME

    CLIENT_IP=$(get_next_ip)
    CLIENT_PRIV=$(wg genkey)
    CLIENT_PUB=$(echo "$CLIENT_PRIV" | wg pubkey)
    SERVER_PUB=$(cat "$WG_DIR/server_public.key")
    SERVER_PUBLIC_IP=$(curl -s https://api.ipify.org)

    echo "[+] Generating client config for $CLIENT_NAME ($CLIENT_IP)"

    CLIENT_CONF="$CURRENT_DIR/${CLIENT_NAME}_wg.conf"
    cat > "$CLIENT_CONF" <<EOF
[Interface]
PrivateKey = $CLIENT_PRIV
Address = $CLIENT_IP/32
DNS = 1.1.1.1

[Peer]
PublicKey = $SERVER_PUB
Endpoint = $SERVER_PUBLIC_IP:$WG_PORT
AllowedIPs = $WG_SUBNET.0/24
PersistentKeepalive = 25
EOF

    echo "[+] Saving client config to $CLIENT_CONF"

    echo "
# $CLIENT_NAME
[Peer]
PublicKey = $CLIENT_PUB
AllowedIPs = $CLIENT_IP/32
" >> "$WG_CONFIG"

    echo "$CLIENT_NAME,$CLIENT_IP" >> "$CLIENTS_DIR/client_list.csv"

    echo "[+] Restarting WireGuard to apply new client..."
    systemctl restart "wg-quick@$WG_INTERFACE"
}

function delete_client() {
    if [ ! -f "$CLIENTS_DIR/client_list.csv" ]; then
        echo "No clients to delete."
        return
    fi

    echo "Available clients:"
    nl -w2 -s'. ' "$CLIENTS_DIR/client_list.csv" | cut -d, -f1

    echo "Enter the number of the client to delete:"
    read -r CLIENT_NUM

    SELECTED_LINE=$(sed -n "${CLIENT_NUM}p" "$CLIENTS_DIR/client_list.csv")
    CLIENT_NAME=$(echo "$SELECTED_LINE" | cut -d, -f1)
    CLIENT_IP=$(echo "$SELECTED_LINE" | cut -d, -f2)

    if [ -z "$CLIENT_NAME" ] || [ -z "$CLIENT_IP" ]; then
        echo "Invalid selection."
        return
    fi

    echo "[+] Deleting $CLIENT_NAME ($CLIENT_IP)..."

    # Remove Peer block from config
    sed -i "/# $CLIENT_NAME/,+3d" "$WG_CONFIG"
    # Remove from used IPs
    sed -i "\|$CLIENT_IP|d" "$USED_IPS_FILE"
    # Remove from client list
    sed -i "\|^$CLIENT_NAME,|d" "$CLIENTS_DIR/client_list.csv"

    echo "[+] Restarting WireGuard after deletion..."
    systemctl restart "wg-quick@$WG_INTERFACE"
}

function show_menu() {
    echo "Choose an action:"
    select opt in "Add New Client" "Delete Existing Client" "Exit"; do
        case $REPLY in
            1) add_client; break ;;
            2) delete_client; break ;;
            3) exit 0 ;;
            *) echo "Invalid option. Try again." ;;
        esac
    done
}

### MAIN
check_root
install_wireguard
init_server_config
show_menu 
