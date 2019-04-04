#!/usr/bin/env bash
# a cloud storage
mkdir -p /root/docker/volumes
docker pull seafileltd/seafile:latest
docker run -d --name seafile
-e SEAFILE_SERVER_HOSTNAME=seafile.example.com
-e SEAFILE_ADMIN_EMAIL=me@example.com
-e SEAFILE_ADMIN_PASSWORD=a_very_secret_password
-v $HOME/docker/volumes/seafile:/shared
-p 80:80 seafileltd/seafile:latest