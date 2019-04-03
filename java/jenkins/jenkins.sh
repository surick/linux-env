#!/usr/bin/env bash
mkdir -p /home/jenkins
cd /home/jenkins
# wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war
nohup java -jar jenkins.war --httpPort=8080 > /dev/null 2>&1 &