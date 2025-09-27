#! /bin/bash
echo "1. setting up .env"
./setup-env.sh

echo "2. setting up muttrc"
./setup-muttrc.sh

echo "3. setting up wallabag client"
docker compose exec -ti wallakindle /home/ubuntu/setup-wallakindle.sh	
