#!/usr/bin/env bash
mkdir -p /home/maven
cd /home/maven
#wget http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz
tar -zxvf apache-maven-3.6.0-bin.tar.gz
mv apache-maven-3.6.0 maven
echo "export PATH=/home/maven/maven/bin:$PATH" >> /etc/profile
source /etc/profile