This is a collection of some random scripts that I got tired of doing over and over.  They are pretty specific to what I'm working on, but if they work for you, great!!


This does an install of docker as recommended from the docker website.  Only been tested on deb 12. 
```bash
sudo wget "https://raw.githubusercontent.com/mellow65/Debian-11-Unifi/main/deb12-docker.sh" -O deb12-docker.sh && sudo chmod +x deb12-docker.sh && ./deb12-docker.sh

curl -o- https://raw.githubusercontent.com/mellow65/Debian-11-Unifi/main/deb12-docker.sh | bash

wget -qO- https://raw.githubusercontent.com/mellow65/Debian-11-Unifi/main/deb12-docker.sh | bash

```

This script will set up your unprivlaged LXC container in Proxmox to be able to advertaise routes on your home network.  If you were to set it up with out this, you would be able to get to your container, but not the rest of your network.  

These lines must be added to your /etc/pve/lxc/1XX.conf file

lxc.cgroup2.devices.allow: c 10:200 rwm

lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file

```bash

curl -o- https://raw.githubusercontent.com/mellow65/Debian-11-Unifi/main/prox_lxc_tail_twin.sh | bash

```

After setting up you can run this command, setting the IP addresses you need. 

```bash
sudo tailscale up --advertise-routes=192.0.2.0/24,198.51.100.0/24

```


