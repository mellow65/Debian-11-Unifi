#! /bin/bash

Colour='\033[1;31m'
less='\033[0m'

echo -e "${Colour}By using this script, you'll backup your immich database to /home/.\n\n${less}"
read -p "If your immich_postgres docker isn't called immich_postgres this script won't work. Press enter to move on, or CTRL+C to run away." version


echo -e "${Colour}\n\nMaking immich backup.\n\n${less}"
sleep 1
docker exec -t immich_postgres pg_dumpall --clean --if-exists --username=postgres | gzip > "/home/dump.sql.gz"

echo -e "${Colour}\n\nYour file should be in your /home/ directory.\n\n${less}"

