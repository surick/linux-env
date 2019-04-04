#!/usr/bin/env bash
docker pull rabbitmq:3-management
#docker run -p 5671:5672 -d --hostname rabbitmq --name rabbitmq rabbitmq:3
docker run -d -p 15671:15672 -p 5671:5672 --hostname rabbitmq --name rabbitmq-management -e RABBITMQ_DEFAULT_USER=root -e RABBITMQ_DEFAULT_PASS=evilcry rabbitmq:3-management
docker ps