#!/usr/bin/env bash
# a tool to crack jrebel active
docker pull ilanyu/golang-reverseproxy
docker run -d -p 8888:8888 ilanyu/golang-reverseproxy