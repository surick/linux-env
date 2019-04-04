#!/usr/bin/env bash
# 获得当前目录
cur=$(pwd)

output_path=${cur}/classes
echo $output_path
if [ ! -d $output_path ]; then
mkdir $output_path
fi
# 获取依赖库和需要编译的java文件
export libs=`find lib -name "*.jar" |xargs|sed "s/ /:/g"`
export javafiles=`find src -name "*.java" |xargs|sed "s/ / /g"`
# 编译
javac -d ${cur}/classes -cp ${libs} -encoding utf-8 ${javafiles}
# 打包
cd $output_path
jar -cvf ${cur}/jfly.war *
cd ${cur}/src
jar -cvf ${cur}/jfly-source.war *
cp -cvf ${cur}/jfly.war /home/tomcat/tomcat/webapps/ROOT/
jar -xf jfly.war
exec /home/tomcat/tomcat/bin/startup.sh
tail -f /home/tomcat/tomcat/logs/catalina.out