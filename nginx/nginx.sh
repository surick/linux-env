#!/usr/bin/env bash
sudo yum -y install nginx
systemctl start nginx
systemctl enable nginx
