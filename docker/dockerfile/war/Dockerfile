FROM daocloud.io/gizwits2015/docker-maven-tomcat
MAINTAINER Jin <root@jinaiya.com>

ENV CATALINA_HOME /usr/local/tomcat

ADD pom.xml /tmp/build/
RUN cd /tmp/build && mvn -q dependency:resolve

ADD src /tmp/build/src
RUN cd /tmp/build && mvn -q -DskipTests=true clean package \
    && rm -rf $CATALINA_HOME/webapps/* \
    && mv target/*.war $CATALINA_HOME/webapps/ROOT.war \
    && cd / && rm -rf /tmp/build

EXPOSE 8080
CMD ["catalina.sh", "run"]