#!/bin/bash

echo "Paso 1: Obtener repositorios"
sudo apt update
echo | sudo add-apt-repository ppa:oisf/suricata-stable

echo "Paso 2: Instalar Suricata y otras dependencias necesarias"
yes | sudo apt install curl git
yes | sudo apt install suricata=6.0.12-0ubuntu1

echo "Paso 3: Habilitar Suricata para que se inicialice con el OS"
sudo systemctl enable suricata.service

echo "Paso 4: Detener el servicio para la configuracion"
sudo systemctl stop suricata.service

echo "Paso 5: Configurando Suricata"
echo "Configurando rotacion de logs..."
sed -i 's/filename: eve.json/filename: eve.json\n      rotate-interval: 1d/g' /etc/suricata/suricata.yaml

echo "Configurando community-id..."
sed -i 's/community-id: false/community-id: true/g' /etc/suricata/suricata.yaml

echo "Configurando interfaz de red..."
interface=$(ip -p -j route show default | grep dev | awk '{print $2}')
interface="${interface:1: -2}"

sed -i "0,/- interface: eth0/s//- interface: "$interface"/g" /etc/suricata/suricata.yaml
sed -i "0,/#threads: auto/s//threads: auto/" /etc/suricata/suricata.yaml

echo "Suricata quedo configurado para trabajar en la interfaz: $interface"

echo "Paso 6: Configurando reglas"
sudo suricata-update

sleep 20
sudo -s  <<EOF
rm /var/lib/suricata/rules/suricata.rules
rm /var/lib/suricata/rules/classification.config
wget https://rules.emergingthreats.net/blockrules/emerging-botcc.suricata.rules
cp ./emerging-botcc.suricata.rules /var/lib/suricata/rules/suricata.rules
exit
EOF

rm ./emerging-botcc.suricata.rules

echo "Paso 7: Iniciar el servicio post configuracion"
sudo systemctl start suricata.service
