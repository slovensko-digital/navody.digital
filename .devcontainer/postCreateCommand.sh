#!/bin/bash

echo "Staring PG server ..."
sudo service postgresql start
echo "Done."

echo "Creating user and their db in psql..."
sudo runuser -l postgres -c 'psql -f /docker-entrypoint-initdb.d/create-db-user.sql'
echo "Done."

echo "Bundle install..."
bundle install
echo "Done."

echo "rake db:setup..."
rake db:setup
echo "Done."
