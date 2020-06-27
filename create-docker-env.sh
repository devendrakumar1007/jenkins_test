#!/bin/bash
cont_count=$1
echo "creating $cont_count containers.."
sleep 2;
for i in `seq $cont_count`
do
	echo "=============================="
    echo "Creating www.petclinic$i container.."
    sleep 1
    docker run --name www.petclinic$i -itd -p 706$i:8080 abc-img /bin/bash
    echo "www.petclinic$i container has been created!"
	echo "=============================="
done
#docker inspect --format {{.NetworkSettings.Networks.bridge.IPAddress}} `sudo docker ps -q` > IPs.txt
#sudo docker ps -a --format "table {{.ID}}\t{{.Names}}"
sudo docker ps -a -q  --format "table {{.Names}}" | grep -i "petclinic" | xargs  sudo  docker inspect --format {{.NetworkSettings.Networks.bridge.IPAddress}}  >> IPs.txt
