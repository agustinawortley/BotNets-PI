#!/bin/bash

CurrentPath=$PWD

echo "Paso 1: Instalar Elasticsearch"

curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list

sudo apt update
sudo apt install elasticsearch

ip -brief address show
ip -brief address show > ip.txt
Line=$(awk '/enp0s3/ {print $3}' ip.txt)
IP=${Line::-3}
echo My ip address: $IP 

echo "Paso 2: Configuración de Elasticsearch"

echo "Configuración de redes de Elasticsearch"
sed -i "s|network.host: 192.168.0.1|network.bind_host: [\"127.0.0.1\", \""$IP"\"]|g" /etc/elasticsearch/elasticsearch.yml

sed -i '$a discovery.type: single-node' /etc/elasticsearch/elasticsearch.yml
sed -i '$a xpack.security.enabled: true' /etc/elasticsearch/elasticsearch.yml

sudo ufw allow in on enp0s3
sudo ufw allow out on enp0s3

echo "Iniciando Elasticsearch"
sudo systemctl start elasticsearch.service

echo "Configuración de contraseñas de Elasticsearch"

cd /usr/share/elasticsearch/bin
sudo yes | sudo ./elasticsearch-setup-passwords auto > $CurrentPath/passwords.txt

#------------------------------------------------------------------------------------------#

sudo apt install kibana

echo "Paso 3: Configuración de Kibana"

echo "Habilitación xpack.securityen Kibana"

cd /usr/share/kibana/bin/
KIBANA=$(sudo ./kibana-encryption-keys generate -q)
echo $KIBANA
echo "$KIBANA" >> /etc/kibana/kibana.yml

sed -i "s|#server.host: \"localhost\"|server.host: \""$IP"\"|g" /etc/kibana/kibana.yml

echo "Configuración de credenciales Kibana"

cd $CurrentPath
Line=$(awk '/PASSWORD kibana_system/ {print $4}' passwords.txt)
cd /usr/share/kibana/bin/
echo kibana_system | sudo ./kibana-keystore add elasticsearch.username
echo $Line | sudo ./kibana-keystore add elasticsearch.password

echo "Inicio de servicio Kibana"
sudo systemctl start kibana.service

#------------------------------------------------------------------------------------------#

sudo apt install filebeat

sed -i "s|#host: \"localhost:5601\"|host: \""$IP":5601\"|g" /etc/filebeat/filebeat.yml
sed -i "s|hosts: [\"localhost:9200\"]|hosts: [\""$IP":9200\"]|g" /etc/filebeat/filebeat.yml

cd $CurrentPath
Line=$(awk '/PASSWORD elastic/ {print $4}' passwords.txt)
sed -i "s|#username: \"elastic\"|username: \"elastic\"|g" /etc/filebeat/filebeat.yml
sed -i "s|#password: \"changeme\"|password: \"$Line\"|g" /etc/filebeat/filebeat.yml

sudo filebeat modules enable suricata

sudo filebeat setup

sudo systemctl start filebeat.service