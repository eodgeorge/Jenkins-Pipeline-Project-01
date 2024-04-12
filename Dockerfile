FROM openjdk:8-jre-slim
FROM ubuntu
FROM tomcat
EXPOSE 8080
COPY *.war /usr/local/tomcat/webapps
WORKDIR /usr/local/tomcat/webapps
CMD java", "-jar", "spring-petclinic-2.4.2.war
