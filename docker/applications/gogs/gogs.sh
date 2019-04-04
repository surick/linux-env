#!/usr/bin/env bash
# a git repo manage
docker pull gogs/gogs
mkdir /root/docker/volumes/gogs
docker run --name=gogs -p 10022:22 -p 10080:3000 -v $HOME/docker/volumes/gogs:/data gogs/gogs