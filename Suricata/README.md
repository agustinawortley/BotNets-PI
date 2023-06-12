# Instalación de Suricata

## ¿Qué es Suricata?
Suricata es un proyecto de código abierto desarrollado por la Open Information Security Foundation (OISF) que ofrece un sistema de detección y prevención de intrusiones en redes de alto rendimiento (IDS/IPS) con monitoreo en tiempo real, análisis y protección contra amenazas en la red.

Suricata es conocido por su capacidad de inspeccionar paquetes de red y detectar diversos tipos de eventos de seguridad, incluyendo intentos de intrusión, infecciones de malware, violaciones de políticas y actividades de red sospechosas. 

Algunas características clave incluyen:
* Arquitectura multi-hilo y multi-núcleo
* Detección basada en firmas: Suricata incluye un sólido lenguaje de firmas que permite la creación e implementación de reglas de detección personalizadas.
* Integración con otras herramientas de seguridad

## Configuraciones que se realizaran
En esta carpeta del repositorio se encuentra un archivo de instalación y configuración llamado *suricata_config.sh*. Dentro de este archivo se harán las siguiente configuraciones:
* Rotación diaria del archivo *eve.json* donde se almacena la información compilada.
* Habilitación del *community-id* para la integración de eventos con herramientas externas.
* Configuración automática de la interfaz de red utilizada por default.
* Descarga y puesta a punto de las [reglas](https://rules.emergingthreats.net/blockrules/emerging-botcc.suricata.rules) para la detección de BotNets propuestas por [emerging threats](https://emergingthreat.net/).

## Requisitos previos
* OS Ubuntu 20.04, server o LTS

Las dependencias necesarias serán instaladas dentro del mismo script.

## Ejecucion

Compruebe que el archivo "suricata_config.sh" tiene permisos de ejecución generales.
```
$ chmod +x suricata_config.sh
```

Iniciar script
```
$ sudo ./suricata_config.sh
```

Una vez terminada la instalación por favor proceder con la [instalación de ell stack ELK](../ELK/README.md).