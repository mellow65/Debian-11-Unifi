#Wanted to make a script following tailscales recomendations to allow advertising routes to your home network.
#I combined the codes from https://tailscale.com/kb/1019/subnets?tab=linux#enable-ip-forwarding
# and https://tailscale.com/kb/1320/performance-best-practices#ethtool-configuration

#!/bin/bash
color='\033[1;31m'

echo -e "${color}Installing ethtool and networkd-dispactcher${reset}"
sleep 1
apt install ethtool -y && apt install networkd-dispatcher -y

echo -e "${color}Making 99-tailscale.conf, adding ipv4 and ipv6 forwarding rules.${reset}"
sleep 1
echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | tee -a /etc/sysctl.d/99-tailscale.conf
sysctl -p /etc/sysctl.d/99-tailscale.conf

echo -e "${color}Setting up to survive reboot.${reset}"
sleep 1
ethtool -K eth0 rx-udp-gro-forwarding on rx-gro-list off

printf '#!/bin/sh\n\nethtool -K %s rx-udp-gro-forwarding on rx-gro-list off \n' "$(ip route show 0/0 | cut -f5 -d" ")" | tee /etc/networkd-dispatcher/routable.d/50-tailscale
chmod 755 /etc/networkd-dispatcher/routable.d/50-tailscale


echo -e "${color}Testing.${reset}"
sleep 1
/etc/networkd-dispatcher/routable.d/50-tailscale
test $? -eq 0 || echo 'An error occurred.'

echo -e "${color}If no error shown, everything worked.${reset}"

