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

Finalmente, se conectara a Kibana usando SSH y su navegador web, y luego cargar e interactuar con los tableros de Kibana que muestran los eventos y alertas de Suricata.

## Requisitos previos

* Suricata ejecutándose en un servidor Ubuntu 20.04.

* También necesitará un segundo servidor para alojar Elasticsearch y Kibana. Este servidor se denominará su servidor de Elasticsearch . Debería ser un servidor Ubuntu 20.04 con:

* 4 GB de RAM y 2 CPU configuradas con un usuario sudo no root. Puede lograr esto siguiendo la Configuración inicial del servidor con Ubuntu 20.04.

Ambos servidores deben poder comunicarse mediante direcciones IP privadas. Puede usar una VPN como WireGuard para conectar sus servidores o usar un proveedor de nube que tenga redes privadas entre hosts. También puede optar por ejecutar Elasticsearch, Kibana, Filebeat y Suricata en el mismo servidor para experimentar. 

## Ejecucion

Compruebe que el archivo "script.sh" tiene permisos de ejecución generales.
```
$ chmod +x script.sh
```

Iniciar script
```
$ ./script.sh
```
