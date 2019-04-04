#!/usr/bin/env bash
cd /home/projects/test
git pull -f
mvn clean install -pl test -am -DskipTests

ids=`ps -ef | grep tomcat | grep -v grep | awk '{print $2}'`
for id in $ids
do
kill -9 $id
done
echo "$ids 已杀死..."

cd /home/tomcat/tomcat/webapps/ROOT
mv -f test-1.0-SNAPSHOT.war test-1.0-SNAPSHOT.war.bak
cp -f /home/projects/test/target/test-1.0-SNAPSHOT.war  /home/tomcat/tomcat/webapps/ROOT/
jar -xf test-1.0-SNAPSHOT.war
cp -f ./resources/application.yml ./WEB-INF/classes/
cp -f ./resources/logback.xml ./WEB-INF/classes/
exec /home/tomcat/tomcat/bin/startup.sh