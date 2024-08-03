#!/bin/bash

Colour='\033[1;31m'
less='\033[0m'

echo -e "${Colour}By using this script, you'll update the system, installs ca-certificates, curl, docker-ce, docker-ce-cli, containerd.io, docker-buildx-plugin, and docker-compose-plugin.\n\n${less}"

read -p "This script will not install any other versions than what is listed above, I am not that smart to figure out how to do that. Press enter to move on, or CTRL+C to run away."

sudo apt-get update -y
sudo apt-get install -y ca-certificates curl

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

sudo add-apt-repository "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable"

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo -e "${Colour}Good job, nothing broke.\n\n${less}"
