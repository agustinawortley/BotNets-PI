#!/bin/bash

echo "Paso 1: Instalar Elasticsearch y Kibana"

curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list

sudo apt update
sudo apt install elasticsearch kibana

ip -brief address show > ip.txt
IP=$(awk '/eth1/ {print $3}' ip.txt)
echo My ip address: $IP 

echo "Paso 2: Configuración de Elasticsearch"

echo "Configuración de redes de Elasticsearch"
sed -i "s|network.host: 192.168.0.1|network.bind_host: ["127.0.0.1", ""$IP""]|g" /etc/elasticsearch/elasticsearch.yml

sed -i '$a discovery.type: single-node' /etc/elasticsearch/elasticsearch.yml
sed -i '$a xpack.security.enabled: true' /etc/elasticsearch/elasticsearch.yml

sudo ufw allow in on eth1
sudo ufw allow out on eth1

echo "Iniciando Elasticsearch"
sudo systemctl start elasticsearch.service

echo "Configuración de contraseñas de Elasticsearch"

cd /usr/share/elasticsearch/bin
sudo ./elasticsearch-setup-passwords auto > passwords.txt


echo "Paso 3: Configuración de Kibana"

echo "Habilitación xpack.securityen Kibana"
cd /usr/share/kibana/bin/
KIBANA=$(sudo ./kibana-encryption-keys generate -q)

sed -i "$a "$KIBANA"" /etc/kibana/kibana.yml


