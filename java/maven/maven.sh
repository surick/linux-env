#!/usr/bin/env bash
mkdir -p /home/maven
cd /home/maven
tar -zxvf apache-maven-3.6.0-bin.tar.gz
mv apache-maven-3.6.0 maven
echo "export PATH=/home/maven/maven/bin:$PATH" >> /etc/profile
source /etc/profile