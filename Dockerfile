FROM openjdk:8-jre-slim
FROM ubuntu
FROM tomcat
COPY *.war /usr/local/tomcat/webapps
WORKDIR  /usr/local/tomcat/webapps
ENTRYPOINT [ "java", "-jar", "spring-petclinic-2.4.2.war", "--server.port=8080"]
