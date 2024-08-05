#Wanted to make a script following docker install from https://docs.docker.com/engine/install/debian/#install-using-the-repository

#!/bin/bash

color='\033[1;31m'
reset='\033[0m'

echo -e "${color}By using this script, you'll update the system, install ca-certificates, curl, docker-ce, docker-ce-cli, containerd.io, docker-buildx-plugin, and docker-compose-plugin.${reset}"

read -p "${color}This script will not install any other versions than what is listed above, I am not that smart to figure out how to do that. Press enter to move on, or CTRL+C to run away.${reset}"

sudo apt-get update -y
sudo apt-get install ca-certificates curl -y

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo -e "${color}Step 4/6: Adding Docker repository...${reset}"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo -e "${color}Step 5/6: Updating package list again...${reset}"
sudo apt-get update

echo -e "${color}Step 6/6: Installing Docker and plugins...${reset}"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo -e "${color}Testing docker was installed correctly${reset}"
sudo docker run hello-world

echo -e "${color}Good job, nothing broke.${reset}"
