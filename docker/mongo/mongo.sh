#!/usr/bin/env bash
docker pull mongo
mkdir -p /root/docker/volumes/mongo
docker run --name mongo -d -p 27017:27017 -v $HOME/docker/volumes/mongo:/data/db mongo mongod
docker exec -it mongo bash
mongo
use admin
db.createUser({user:"foouser",pwd:"foopwd",roles:[{role:"root",db:"admin"}]})
exit
exit