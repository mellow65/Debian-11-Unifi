This is a collection of some random scripts that I got tired of doing over and over.  They are pretty specific to what I'm working on, but if they work for you, great!!

This is a copy of a Proxmox Helper script for filebrowser, but allows you to select the port you want to use. 
```bash
bash -c "$(wget -qLO - https://github.com/mellow65/Debian-11-Unifi/raw/main/filebrowser.sh)"
```

This is a wireguard installer
```bash
wget https://raw.githubusercontent.com/mellow65/Debian-11-Unifi/refs/heads/main/wg-install.sh -O wg-install.sh && bash wg-install.sh
```

Client side, copy config file to /etc/wireguard/wg0.conf


Bring up wg0
```bash
wg-quick up wg0
```

Stop wg0
```bash
wg-quick down wg0
```

Start wg0 on boot
```bash
systemctl enable wg-quick@wg0
```

Show status
```bash
wg show
```


This will automate the install of Docker
```bash
curl -o- https://raw.githubusercontent.com/mellow65/Debian-11-Unifi/main/deb12-docker.sh | bash
```








This section will set up your unprivlaged LXC container in Proxmox to be able to advertaise routes on your home network for tailscale and twingate.  If you were to set it up with out this, you would be able to access your container, but not the rest of your network.  

These lines must be added to your /etc/pve/lxc/1XX.conf file

```bash
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
```
Reboot container.

Install tailscale and twingate via their respectible recomended methods.

Twingate will output a copy/paste command from the admin page, there is nothing more to do in the lxc terminal.

Tailscale will requre extra configuration via the command line.

This will set up the networking in the container to allow advertising routes on your network.  These are pulled from tailscales websites.
```bash
curl -o- https://raw.githubusercontent.com/mellow65/Debian-11-Unifi/main/prox_lxc_tail_twin.sh | bash
```

After setting up you can run this command, change IP address or ranges to fit your needs.
```bash
sudo tailscale up --advertise-routes=192.168.50.0/24,192.168.100.0/24
```


