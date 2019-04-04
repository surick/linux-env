#!/usr/bin/env bash
mkdir -p /home/tomcat
cd /home/tomcat
#wget http://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-8/v8.5.39/bin/apache-tomcat-8.5.35.tar.gz
tar -zxvf apache-tomcat-8.5.35.tar.gz
mv apache-tomcat-8.5.35 tomcat
exec /home/tomcat/bin/startup.sh
tail -f /home/tomcat/logs/catalina.out
