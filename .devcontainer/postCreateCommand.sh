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

echo "Yarn install..."
yarn install
echo "Done."

echo "bin/setup..."
bin/setup
echo "Done."

echo "set node to development..."
export NODE_ENV=development
echo "Done."
