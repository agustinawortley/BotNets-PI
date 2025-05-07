# Detección y remediación de equipos infectados con botnets

## Descripción del problema
Las botnets representan una de las principales amenazas que afectan a los puestos de trabajo de las organizaciones. A través de ellas los criminales consiguen comprometer equipos sin el consentimiento de los usuarios con diferentes objetivos como el de  usarlos como trampolín para el lanzamiento de distintos tipos de ataques hacia terceros, denegación de servicio, fraude y robo de identidad, extorsión, robo de información confidencial, etc.
	
Los ataques actuales se concentran en el usuario y en las organizaciones. Detrás de los ataques existen equipos comprometidos, ubicados en hogares, escuelas, organizaciones privadas y gubernamentales;que están infectados con un bot que se comunica con un bot controller y otros bots que forman lo que comúnmente se conoce como botnet.  

La presencia de un canal de comunicación con un controlador es lo que diferencia a los botnets de otros tipos de ataques.
Las botnets representan un problema real y de rápida evolución y constituyen una de las amenazas de seguridad más preocupantes debido a que causan pérdidas financieras y daños a las organizaciones de todo el mundo.

Por otro lado, las redes universitarias son un terreno fértil para la diseminación de estas infecciones ya que: 

* Las redes son abiertas para docentes y estudiantes
* Existe mucha flexibilidad para conectar equipos (en algunos casos la conexión a la red wifi se realiza sin contraseña) 
* Las redes locales tienen administradores locales que aplican sus propios controles,
* Los equipos que se conecta a la red no son masterizados, tienen distintos niveles de seguridad
* Las computadoras personales muchas veces son administradas por personas sin la formación necesaria; 
* Algunos equipos equipos se utilizan tanto en la universidad como en la casa particulares e incluso pueden tener muchos usuarios con fines muy diversos, asistir o dictar clases, juegos en línea, esparcimiento, etc.

Adicionalmente, la topología de la red es al mismo tiempo una ventaja porque su conexión con internet se restringe a unos pocos enlaces administrados en forma centralizada y una desventaja porque la anonimización de las comunicaciones proporcionada por el enmascaramiento de direcciones IP afecta a la imagen de la Universidad por los ataques iniciados desde el interior de la red.

## Objetivo general

### El objetivo de este trabajo es estudiar las botnet:

* Identificar distintos patrones de comportamiento, 
* Entender sus características, componentes, arquitecturas existentes y funcionamiento

### Adicionalmente se pretende 
* Detectar y localizar equipos comprometidos en la red de la UNC, 
* Informar a los usuarios 
* Alertar a los responsables de las redes 
* Proponer remediaciones a las infecciones.

Finalmente, Integrar un proceso de detección, localización y remediación de botnets, compuesto por software, a los sistemas de respuesta a incidentes de ciberseguridad existentes en la UNC.

## Referencias
[Botnet Literature Review](https://moam.info/botnet-literature-review-pdf-download-available_59b2bfe71723dddac6d86948.html)

[Botnet tracker](http://botnet-tracker.blogspot.com)

[Referencias varias](https://en.wikipedia.org/wiki/Botnet)

# Uso del repositorio

Para comenzar con la instalación de las herramientas por favor referirse a la [Guía de instalación de Suricata](./Suricata/README.md).