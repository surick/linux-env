#!/usr/bin/env bash
# jvm params
JAVA_OPTS=' -server -Xms3g -Xmx3g -Xmn1g -XX:MetaspaceSize=512m -XX:MaxMetaspaceSize=1024m -XX:+UseG1GC -XX:G1HeapRegionSize=16m -XX:G1ReservePercent=25 -XX:InitiatingHeapOccupancyPercent=30 -XX:SoftRefLRUPolicyMSPerMB=0 -XX:SurvivorRatio=8 -XX:+DisableExplicitGC -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCApplicationStoppedTime -XX:+PrintAdaptiveSizePolicy -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=5 -XX:GCLogFileSize=30m -verbose:gc -Xloggc:ukefu_gc.log'
# tomcat params
TOMCAT_CONF='<Connector port=\"80\" protocol=\"HTTP/1.1\" URIEncoding=\"UTF-8\" minSpareThreads=\"25\" maxSpareThreads=\"75\" enableLookups=\"false\" disableUploadTimeout=\"true\" acceptCount=\"2000\" maxThreads=\"1000\" maxProcessors=\"1500\" minProcessors=\"5\" useURIValidationHack=\"false\" compression=\"on\" compressionMinSize=\"2048\" compressableMimeType=\"text/html,text/xml,text/javascript,text/css,text/plain\"'
yum -y install wget

echo "create directory"
mkdir -p /home/tomcat
cd /home/tomcat

echo "download tomcat"
wget https://gitee.com/surick/linux-env/raw/master/java/tomcat/apache-tomcat-8.5.35.tar.gz

echo "extract tomcat"
tar -zxvf apache-tomcat-8.5.35.tar.gz
mv apache-tomcat-8.5.35 tomcat-8.5.35
cd tomcat-8.5.35
TOMCAT_HOME=$PWD

echo "modify config"
cd $TOMCAT_HOME/conf
sed -i "s#<Connector port=\"8080\" protocol=\"HTTP/1.1\"#$TOMCAT_CONF#" server.xml
cd $TOMCAT_HOME/bin
sed -i 's/0027/0022/' catalina.sh
sed -i 's/webresources/&$JAVA_OPTS/' catalina.sh

echo "start server"
./startup.sh && tail -f $TOMCAT_HOME/logs/catalina.out
