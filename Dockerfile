FROM ubuntu:16.04 
MAINTAINER "info@gamutgurus.com"
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk
ENV JAVA_HOME /usr
ADD apache-tomcat-7.0.104.tar.gz /root
COPY server.xml /root/apache-tomcat-7.0.104/conf/
COPY target/petclinic.war /root/apache-tomcat-7.0.104/webapps
EXPOSE 8080
CMD chmod +x /root/apache-tomcat-7.0.104/bin/catalina.sh
CMD ["catalina.sh", "run"]



