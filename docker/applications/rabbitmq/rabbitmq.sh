#!/usr/bin/env bash
docker pull rabbitmq:3-management
# docker run -d --hostname rabbitmq --name rabbitmq rabbitmq:3
docker run -d --hostname rabbitmq --name rabbitmq-management -e RABBITMQ_DEFAULT_USER=root -e RABBITMQ_DEFAULT_PASS=evilcry rabbitmq:3-management
docker ps