#!/bin/bash
cont_count=$1
echo "creating $cont_count containers.."
sleep 2;

# Remvoe the old docker  if exist

dockerList=`sudo docker ps -a -q  --format "table {{.Names}}" | grep -i "petclinic\|nginx_load_balancder" `

if [ -z "$dockerList" ] ; then
        echo "String null"
else
sudo docker ps -a -q  --format "table {{.Names}}" | grep -i "petclinic\|nginx_load_balancder"  | xargs  sudo  docker rm -f
fi



script="upstream loadbalance { \n least_conn; \n "
script2=""
echo "$script"
servername_ip=`ifconfig eth1 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1`
for i in `seq $cont_count`
do
	echo "=============================="
        echo "Creating www.petclinic$i container.."
        sleep 1
        sudo docker run --name www.petclinic$i -itd -p 706$i:8080 abc-img /bin/bash
        echo "www.petclinic$i container has been created!"
        
        
	echo "=============================="

        script2="$script2 \n server $servername_ip:706$i;\n "
done

script3="$script $script2  \n } \n server { \n location / { \n proxy_pass http://loadbalance;  \n } \n }"
cd  nginx
rm  -f nginx.conf
echo $script3 >nginx.conf
#sudo docker ps -a -q  --format "table {{.Names}}" | grep -i "petclinic" | xargs  sudo  docker inspect --format {{.NetworkSettings.Networks.bridge.IPAddress}}  >> IPs.txt
# nginx image creation  
docker build -t load-balance-nginx .

#nginx docker conainer creation for load balancer 
docker run --name nginx_load_balancder -p 8080:80 -d load-balance-nginx

# Restart the shutdown  tomcat server 
#sudo docker ps -a -q  --format "table {{.Names}}" | grep -i "pet" | xargs  sudo  docker  exec   /root/apache-tomcat-7.0.104/bin/shutdown.sh
#sudo docker ps -a -q  --format "table {{.Names}}" | grep -i "pet" | xargs  sudo  docker  exec   /root/apache-tomcat-7.0.104/bin/startup.sh
sudo docker exec www.petclinic2 /root/apache-tomcat-7.0.104/bin/shutdown.sh
sudo docker exec www.petclinic2 /root/apache-tomcat-7.0.104/bin/startup.sh
sudo docker exec www.petclinic1 /root/apache-tomcat-7.0.104/bin/shutdown.sh
sudo docker exec www.petclinic1 /root/apache-tomcat-7.0.104/bin/startup.sh


