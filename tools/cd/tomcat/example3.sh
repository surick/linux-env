#!/usr/bin/env bash
cd /home/projects/test

git checkout release && git pull

mvn -Dmaven.test.skip=true clean install

cd /home/projects/test

git checkout dev_feature && git pull

mvn -Dmaven.test.skip=true clean package

echo "------Kill SID------"

NAME=tomcat

echo "SID Name="$NAME

ID=`ps -ef | grep "$NAME" | grep -v "$0" | grep -v "grep" | awk '{print $2}'`

echo "IDs = "$ID

for id in $ID

do

kill -9 $id

echo "killed $id"

done

echo "------Kill SID------"

cp /home/projects/test/target/test-1.0-SNAPSHOT.war /home/tomcat/tomcat/webapps/ROOT

rm -rf /home/tomcat/tomcat/webapps/ROOT/META-INF

rm -rf /home/tomcat/tomcat/webapps/ROOT/WEB-INF

cd /home/tomcat/tomcat/webapps/ROOT
jar -xvf test-1.0-SNAPSHOT.war
echo "查看解压结果"
ll
ls -l
echo "查看完"

cd /home/tomcat/tomcat/bin

./startup.sh && tail -f ../logs/catalina.out