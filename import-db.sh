#!/bin/bash
echo "Importing database..."
docker compose exec -T db mysql -u root -prootpassword hotel_management < mysql-init/01-init.sql
echo "Done! Checking tables..."
docker compose exec db mysql -u root -prootpassword -e "USE hotel_management; SHOW TABLES;"