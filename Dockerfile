FROM ubuntu:16.04 
MAINTAINER "info@gamutgurus.com"
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk
ENV JAVA_HOME /usr
ADD apache-tomcat-7.0.104.tar.gz /root
COPY target/petclinic.war /root/apache-tomcat-7.0.104/webapps
ENTRYPOINT /root/apache-tomcat-7.0.104/bin/startup.sh && bash

