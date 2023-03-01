#! /bin/bash

Colour='\033[1;31m'
less='\033[0m'

echo -e "${Colour}By using this script, you'll update the system, install the needed MongoDB 3.6 because that's the latest one that will work, Java 11, and the latest stable UniFi controller.\n\n${less}"
read -p "This script will not install any other versions than what is listed above, I am not that smart to figure out how to do that. Press enter to move on, or CTRL+C to run away." version


echo -e "${Colour}\n\nAdding the Mongodb Key and Mongodb Server 3.6 Repo.\n\n${less}"
sleep 1
curl https://pgp.mongodb.com/server-3.6.asc | sudo gpg --dearmor | sudo tee /usr/share/keyrings/mongodb-org-server-3.6-archive-keyring.gpg >/dev/null    
echo 'deb [signed-by=/usr/share/keyrings/mongodb-org-server-3.6-archive-keyring.gpg] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/3.6 multiverse' | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list > /dev/null

echo -e "${Colour}\n\nAdding the Unifi Key and Unifi Repo.\n\n${less}"
sleep 1
curl https://dl.ui.com/unifi/unifi-repo.gpg | sudo tee /usr/share/keyrings/ubiquiti-archive-keyring.gpg >/dev/null  #add unifi repository key
echo 'deb [signed-by=/usr/share/keyrings/ubiquiti-archive-keyring.gpg] https://www.ui.com/downloads/unifi/debian stable ubiquiti' | sudo tee /etc/apt/sources.list.d/100-ubnt-unifi.list > /dev/null   #add unifi repository

echo -e "${Colour}\n\nThe system will now upgrade all the software and firmware, as well as clean up old/unused packages.\n\n${less}"
sleep 1
sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt-get autoclean -y


echo -e "${Colour}\n\n Java 11 is going to be installed\n\n${less}"
sleep 1
sudo apt install openjdk-11-jre-headless -y


echo -e "${Colour}\n\nMongoDB will now be installed.\n\n${less}"
sleep 1
sudo apt install -y mongodb-org-server 


echo -e "${Colour}\n\nMongoDB is going to start and be enabled.\n\n${less}"
sleep 1
sudo systemctl start mongod  
sudo systemctl enable mongod
echo -e "${Colour}\n\nDone.\n\n${less}"
sleep 1


echo -e "${Colour}\n\nThe UniFi controller will be installed now.\n\n${less}"
sleep 1
sudo apt install unifi

echo -e "${Colour}\n\nTo finish the installation, a reboot is required. Starting a reboot in 3 seconds.\n\n${less}"
sleep 3
echo -e "${Colour}\nRestarting the computer now.\n${less}"
sudo reboot now
