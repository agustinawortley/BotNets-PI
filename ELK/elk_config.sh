#!/bin/bash

CurrentPath=$PWD

echo -e "\033[1;37;41mPaso 1: \033[0;37mObtener repositorios"

echo "Instalando dependencias previas..."
sudo apt update
yes | sudo apt install curl git
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list

echo -e "\033[1;37;41mPaso 2: \033[0;37mInstalar Elasticsearch"
sudo apt update
sudo apt install elasticsearch

echo -e "\033[1;37;41mPaso 3: \033[0;37mRegistrar dirección IP del equipo"
ip -brief address show
ip -brief address show > ip.txt

interface=$(ip -p -j route show default | grep dev | awk '{print $2}')
interface="${interface:1: -2}"

Line=$(awk "/$interface/ {print $3}" ip.txt)
IP=$(echo $Line | awk -v N=3 '{print $N}')
IP=${IP::-3}

echo -e "\033[1;37;41mPaso 4: \033[0;37mConfiguración de Elasticsearch"

echo "Configuración de redes de Elasticsearch"
sed -i "s|network.host: 192.168.0.1|network.bind_host: [\"127.0.0.1\", \""$IP"\"]|g" /etc/elasticsearch/elasticsearch.yml

sed -i '$a discovery.type: single-node' /etc/elasticsearch/elasticsearch.yml
sed -i '$a xpack.security.enabled: true' /etc/elasticsearch/elasticsearch.yml

sudo ufw allow in on $interface
sudo ufw allow out on $interface

echo "Inicio de servicio Elasticsearch"
sudo systemctl start elasticsearch.service

echo "Configuración de contraseñas, ver archivo passwords.txt para mas información"
cd /usr/share/elasticsearch/bin
sudo yes | sudo ./elasticsearch-setup-passwords auto > $CurrentPath/passwords.txt

#------------------------------------------------------------------------------------------#
echo -e "\033[1;37;41mPaso 5: \033[0;37mInstalar Kibana"
sudo apt install kibana

echo -e "\033[1;37;41mPaso 6: \033[0;37mConfiguración de Kibana"

#echo "Habilitación xpack.securityen Kibana"
cd /usr/share/kibana/bin/
KIBANA=$(sudo ./kibana-encryption-keys generate -q)
echo $KIBANA
echo "$KIBANA" >> /etc/kibana/kibana.yml

sed -i "s|#server.host: \"localhost\"|server.host: \""$IP"\"|g" /etc/kibana/kibana.yml

#echo "Configuración de credenciales Kibana"
cd $CurrentPath
Line=$(awk '/PASSWORD kibana_system/ {print $4}' passwords.txt)
cd /usr/share/kibana/bin/
echo kibana_system | sudo ./kibana-keystore add elasticsearch.username
echo $Line | sudo ./kibana-keystore add elasticsearch.password

echo "Inicio de servicio Kibana"
sudo systemctl start kibana.service

#------------------------------------------------------------------------------------------#
echo -e "\033[1;37;41mPaso 7: \033[0;37mInstalar Filebeat"
sudo apt install filebeat

echo -e "\033[1;37;41mPaso 8: \033[0;37mConfiguración de Filebeat"

sed -i "s|#host: \"localhost:5601\"|host: \""$IP":5601\"|g" /etc/filebeat/filebeat.yml
sed -i "s|hosts: [\"localhost:9200\"]|hosts: [\""$IP":9200\"]|g" /etc/filebeat/filebeat.yml

cd $CurrentPath
Line=$(awk '/PASSWORD elastic/ {print $4}' passwords.txt)
sed -i "s|#username: \"elastic\"|username: \"elastic\"|g" /etc/filebeat/filebeat.yml
sed -i "s|#password: \"changeme\"|password: \"$Line\"|g" /etc/filebeat/filebeat.yml

sudo filebeat modules enable suricata

sudo filebeat setup

echo "Inicio de servicio Filebeat"
sudo systemctl start filebeat.service

#------------------------------------------------------------------------------------------#
echo "#------------------------------------------------------------------------------------------#"
echo -e "\033[1;37;41mPara iniciar entrar a $IP:5601"
echo "usuario: elastic"
echo "password: $Line"