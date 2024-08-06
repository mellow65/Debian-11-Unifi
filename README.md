This is a collection of some random scripts that I got tired of doing over and over.  They are pretty specific to what I'm working on, but if they work for you, great!!


This does an install of docker as recommended from the docker website.  Only been tested on deb 12. 
```bash
sudo wget "https://raw.githubusercontent.com/mellow65/Debian-11-Unifi/main/deb12-docker.sh" -O deb12-docker.sh && sudo chmod +x deb12-docker.sh && ./deb12-docker.sh

curl -o- https://raw.githubusercontent.com/mellow65/Debian-11-Unifi/main/deb12-docker.sh | bash

wget -qO- https://raw.githubusercontent.com/mellow65/Debian-11-Unifi/main/deb12-docker.sh | bash

```

