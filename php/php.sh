#!/usr/bin/env bash
sudo yum install httpd
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
sudo yum install php php-mysql
sudo yum install php-fpm
sudo systemctl restart httpd.service
