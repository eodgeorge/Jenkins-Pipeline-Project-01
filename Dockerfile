FROM openjdk:8-jre-slim
FROM ubuntu
FROM tomcat
COPY */*.war /usr/local/tomcat/webapps
WORKDIR  /usr/local/tomcat/webapps
RUN apt update -y && apt install curl -y
RUN curl -O https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip && \
    apt-get install unzip -y  && \
    unzip newrelic-java.zip -d  /usr/local/tomcat/webapps
ENV JAVA_OPTS="$JAVA_OPTS -javaagent:/usr/local/tomcat/webapps/newrelic/newrelic.jar"
ENV NEW_RELIC_APP_NAME="myapp"
ENV NEW_RELIC_LOG_FILE_NAME=STDOUT
ENV NEW_RELIC_LICENCE_KEY="eu01xx31c21b57a02a5da0d33d8706beb182NRAL"
EXPOSE 8080
COPY *.war /usr/local/tomcat/webapps
WORKDIR /usr/local/tomcat/webapps
CMD java", "-jar", "spring-petclinic-2.4.2.war
