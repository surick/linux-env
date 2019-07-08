#!/usr/bin/env bash
sudo yum -y install httpd
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
sudo yum -y install php php-mysql
sudo yum -y install php-fpm
sudo systemctl restart httpd.service
