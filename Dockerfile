
FROM tomcat:latest
WORKDIR  /usr/local/tomcat/webapps
RUN apt-get update -y && apt-get install -y curl unzip wget
RUN curl -O https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip && \
    unzip -o newrelic-java.zip -d /usr/local/tomcat/webapps && \
    rm newrelic-java.zip
ENV JAVA_OPTS="$JAVA_OPTS -javaagent:/usr/local/tomcat/webapps/newrelic/newrelic.jar"
ENV NEW_RELIC_APP_NAME="myapp"
ENV NEW_RELIC_LOG_FILE_NAME=STDOUT
ENV NEW_RELIC_LICENSE_KEY="eu01xx31c21b57a02a5da0d33d8706beb182NRAL"
ADD ./newrelic.yml /usr/local/tomcat/webapps/newrelic/newrelic.yml
COPY ./target/*.war /usr/local/tomcat/webapps/
RUN wget -qO- https://github.com/prometheus/node_exporter/releases/download/v1.8.0/node_exporter-1.8.0.linux-amd64.tar.gz \
    | tar xz --strip-components=1 --directory=/usr/local/bin/ node_exporter-1.8.0.linux-amd64/node_exporter &
EXPOSE 8080
EXPOSE 9100
CMD ["catalina.sh", "run"]



# FROM openjdk:alpine
# FROM ubuntu
# FROM tomcat
# RUN apt update
# COPY ./target/*.war /usr/local/tomcat/webapps
# EXPOSE 8080
# EXPOSE 9100
# WORKDIR  /usr/local/tomcat/webapps
# RUN apt update -y && apt install curl -y
# RUN curl -O https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip && \
#     apt-get install unzip -y  && \
#     unzip newrelic-java.zip -d  /usr/local/tomcat/webapps
# ENV JAVA_OPTS="$JAVA_OPTS -javaagent:/usr/local/tomcat/webapps/newrelic/newrelic.jar"
# ENV NEW_RELIC_APP_NAME="myapp"
# ENV NEW_RELIC_LOG_FILE_NAME=STDOUT
# ENV NEW_RELIC_LICENCE_KEY="eu01xx31c21b57a02a5da0d33d8706beb182NRAL"
# ADD ./newrelic.yml /usr/local/tomcat/webapps/newrelic/newrelic.yml
# RUN wget -qO- https://github.com/prometheus/node_exporter/releases/download/v1.8.0/node_exporter-1.8.0.linux-amd64.tar.gz \
#     | tar xz --strip-components=1 --directory=/usr/local/bin/ node_exporter-1.8.0.linux-amd64/node_exporter &
# CMD ["catalina.sh", "run"]





# CMD ["java", "-javaagent:/usr/local/tomcat/webapps/newrelic/newrelic.jar", "-jar", "spring-petclinic-2.4.3.war"]  
