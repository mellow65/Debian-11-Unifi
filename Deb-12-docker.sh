#Wanted to make a script following docker install from https://docs.docker.com/engine/install/debian/#install-using-the-repository
#! /bin/bash

Colour='\033[1;31m'
less='\033[0m'

echo -e "${Colour}By using this script, you'll update the system, installs ca-certificates, curl, docker-ce, docker-ce-cli, containerd.io, docker-buildx-plugin, and docker-compose-plugin.\n\n${less}"
read -p "This script will not install any other versions than what is listed above, I am not that smart to figure out how to do that. Press enter to move on, or CTRL+C to run away." version


echo -e "${Colour}\n\nAdding curl and ca-certificates.\n\n${less}"
sleep 1
sudo apt-get update -y
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings


echo -e "${Colour}\n\nGetting key from docker.\n\n${less}"
sleep 1
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc


echo -e "${Colour}\n\nAdding the Docker Key.\n\n${less}"
sleep 1
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


echo -e "${Colour}\n\nThe system will now upgrade all the software and firmware, as well as clean up old/unused packages.\n\n${less}"
sleep 1
sudo apt-get update


echo -e "${Colour}\n\n Docker is going to be installed\n\n${less}"
sleep 1
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y


echo -e "${Colour}\n\nGood job, nothing broke.\n\n${less}"



