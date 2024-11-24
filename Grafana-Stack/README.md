# Integración de Grafana, Loki y Promtail para la Gestión de Logs

Este proyecto describe cómo configurar un sistema de gestión de logs utilizando Grafana, Loki y Promtail en un entorno Ubuntu 20.04. Este stack permite centralizar, visualizar y analizar logs de sistemas y aplicaciones en tiempo real.

## Componentes

Los principales componentes utilizados en esta configuración son:

* **Grafana** Herramienta de visualización que permite explorar y analizar los datos almacenados en Loki.
* **Loki** Un sistema de almacenamiento de logs diseñado para ser altamente eficiente y fácil de integrar con Grafana.
* **Promtail** Un cliente ligero que recoge los logs de sistemas y los envía a Loki.

## Objetivos
El objetivo de este proyecto es configurar un stack para la centralización y análisis de logs mediante los siguientes pasos:

* Instalar y configurar Grafana.
* Instalar y configurar Loki.
* Instalar y configurar Promtail.
* Recolectar los logs generados por el sistema y visualizarlos en Grafana.

## Requisitos previos

* Sistema Operativo: Ubuntu 20.04 (Server o LTS).
* Recursos del sistema: 4 GB de RAM y 2 CPU (mínimo recomendado).
* [Instalación de Suricata](../Suricata/README.md)

## Ejecucion

Compruebe que el archivo "elk_config.sh" tiene permisos de ejecución generales.
```
$ chmod +x grafana.sh
```

Iniciar script
```
$ sudo ./grafana.sh
```