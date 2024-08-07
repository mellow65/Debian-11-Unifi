#Wanted to make a script following tailscales recomendations to allow  advertising routes to your home network.
#I combined the codes from https://tailscale.com/kb/1019/subnets?tab=linux#enable-ip-forwarding
# and https://tailscale.com/kb/1320/performance-best-practices#ethtool-configuration

#!/bin/bash
color='\033[1;31m'

echo -e "${color}Installing ethtool and networkd-dispactcher${reset}"

apt install ethtool -y && apt install networkd-dispatcher -y

echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | tee -a /etc/sysctl.d/99-tailscale.conf
sysctl -p /etc/sysctl.d/99-tailscale.conf

NETDEV=$(ip route show 8.8.8.8 | cut -f5 -d' ')

ethtool -K eth0 rx-udp-gro-forwarding on rx-gro-list off

printf '#!/bin/sh\n\nethtool -K %s rx-udp-gro-forwarding on rx-gro-list off \n' "$(ip route show 0/0 | cut -f5 -d" ")" | tee /etc/networkd-dispatcher/routable.d/50-tailscale
chmod 755 /etc/networkd-dispatcher/routable.d/50-tailscale

sudo /etc/networkd-dispatcher/routable.d/50-tailscale
test $? -eq 0 || echo 'An error occurred.'


sudo tailscale up --advertise-routes=192.0.2.0/24,198.51.100.0/24
