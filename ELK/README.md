# Integrar Suricata con Elasticsearch, Kibana y Filebeat

Para crear una herramienta de Gestión de eventos e información de seguridad (SIEM) utilizando Elastic Stack y Ubuntu 20.04. Las herramientas SIEM se utilizan para recopilar, agregar, almacenar y analizar datos de eventos para buscar amenazas de seguridad y actividad sospechosa en sus redes y servidores.

## Componentes

Los *componentes* que utilizará para construir su propia herramienta SIEM son:

* **Elasticsearch** para almacenar, indexar, correlacionar y buscar los eventos de seguridad que provienen de su servidor Suricata.
* **Kibana** para mostrar y navegar por los registros de eventos de seguridad que se almacenan en Elasticsearch.
* **Filebeat** para analizar los de Suricata `eve.json` log y envíe cada evento a Elasticsearch para su procesamiento.
* **Suricata** para escanear el tráfico de su red en busca de eventos sospechosos y registrar o descartar paquetes no válidos.

## Objetivos

Primero instalará y configurará Elasticsearch y Kibana con algunas configuraciones de autenticación específicas. Luego agregará Filebeat a su sistema Suricata para enviar su `eve.json` se registra en Elasticsearch.

## Requisitos previos
* OS Ubuntu 20.04, server o LTS

* [Instalación de Suricata](../Suricata/Suricata.md)

* 8 GB de RAM y 4 CPU configuradas con un usuario sudo no root

## Ejecucion

Compruebe que el archivo "elk_config.sh" tiene permisos de ejecución generales.
```
$ chmod +x elk_config.sh
```

Iniciar script
```
$ sudo ./elk_config.sh
```
