#!/usr/bin/env bash
mkdir -p /home/jenkins
cd /home/jenkins
nohup java -jar jenkins.war --httpPort=8080 > /dev/null 2>&1 &