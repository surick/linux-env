#!/usr/bin/env bash
mkdir -p /home/java
tar -zxvf jdk-8u192-linux-x64.tar.gz
echo "export JAVA_HOME=/home/java/jdk1.8.0_192" >> /etc/profile
echo "export PATH=$JAVA_HOME/bin:$PATH" >> /etc/profile
source /etc/profile