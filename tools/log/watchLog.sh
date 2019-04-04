#!/usr/bin/env bash
cd /home/tomcat/tomcat/logs
echo /dev/null > catalina.out
tail -f catalina.out