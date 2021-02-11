# coopesantos-comercial
Repositorio Comercial para los sistemas de consultas del departamento Comercial 


# Crear las imagenes necesarias:

- Clonar repositorio
- Ejecutar Script build.sh

## Dependencias:

- MariaDB

# Imagenes:

## IVR: (coopesantos/ivr)

Esta imagen contiene el servicio de asterisk junto con los scripts AGI para el funcionamiento necesario

### Volumenes:

- /opt/asterisk/etc/asterisk
- /opt/asterisk/var/lib/asterisk/sounds
- /opt/asterisk/var/spool/asterisk
- /var/log/asterisk

## IVRGUI: (coopesantos/ivrgui)

Contiene el servicio de Webmin junto a los modulos de configuracion hechos a la medida 

### Volumenes

- /data

