#!/usr/bin/env bash
mkdir -p /home/java
cd /home/java
# wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3a%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjdk8-downloads-2133151.html; oraclelicense=accept-securebackup-cookie;" "https://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u192-linux-x64.tar.gz"
tar -zxvf jdk-8u192-linux-x64.tar.gz
echo "export JAVA_HOME=/home/java/jdk1.8.0_192" >> /etc/profile
echo "export PATH=$JAVA_HOME/bin:$PATH" >> /etc/profile
source /etc/profile