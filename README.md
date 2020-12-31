# coopesantos-comercial
Repositorio Comercial para los sistemas de consultas del departamento Comercial 


# IVR
## Cosntruir el Contenedor:
- docker build -t "coopesantos/ivr:tag" ./

## Volumenes:
- /opt/asterisk/etc/asterisk: Archivos de configuracion para los contextos de asterisk 
- /opt/asterisk/var/lib/asterisk/sounds: Carpeta para almacenar los audios
- /opt/asterisk/var/spool/asterisk: Archivos de grabaciones de Asterisk (por si se llega a ocupar)
- /var/log/asterisk: Almacena todos los logs de asterisk incluyendo los de consulta con MSSQL
