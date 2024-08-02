#!/bin/bash

Colour='\033[1;31m'
less='\033[0m'

echo -e "${Colour}By using this script, you'll restore your immich database. .\n\n${less}"
read -p "This will erase all volumes!! Use with caution! Press enter to move on, or CTRL+C to run away." -n 1 -s
echo

read -p "Enter the directory where your docker-compose.yml file is for Immich: " directory

echo "You entered: $directory"

# Confirmation check
read -p "Double check your docker-compose.yml file is located in $directory? (y/n) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "Proceeding with restoration..."
  cd "$directory" || exit 1
  docker compose down -v # CAUTION! Deletes all Immich data to start from scratch.
  docker compose pull # Update to latest version of Immich (if desired)
  docker compose create   # Create Docker containers for Immich apps without running them.
  docker start immich_postgres    # Start Postgres server
  sleep 10

  # Ask for the location of the dump.sql.gz file
  read -p "Enter the path to the dump.sql.gz file: " backup_dir

  echo "Restoring from backup file: $backup_dir/dump.sql.gz"

  gunzip < "$backup_dir/dump.sql.gz" \
  | sed "s/SELECT pg_catalog.set_config('search_path', '', false);/SELECT pg_catalog.set_config('search_path', 'public, pg_catalog', true);/g" \
  | docker exec -i immich_postgres psql --username=postgres    # Restore Backup

  docker compose down
  
  echo " Restoration complete.  Go map your photos now in the .env file and restart your dockers with docker compose up -d"
else
  echo " Restoration cancelled."
fi
