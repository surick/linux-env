#!/usr/bin/env bash
sudo yum install nginx
systemctl start nginx
systemctl enable nginx