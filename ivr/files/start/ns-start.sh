#!/bin/bash


#Funciones:
function check_default(){

    astvar=$(ls -A  /var/lib/asterisk )
    astetc=$(ls -A /etc/asterisk )
    astspool=$(ls -A /var/spool/asterisk )

    if [ "$astvar" = "" ];then
        cp -rf /opt/asterisk/samples/asterisk-lib/* /var/lib/asterisk/
    fi

    if [ "$astetc" = "" ];then
        cp -rf /opt/asterisk/samples/asterisk-etc/* /etc/asterisk/
    fi

    if [ "$astspool" = "" ];then
        cp -rf /opt/asterisk/samples/asterisk-spool/* /var/spool/asterisk/
        chown -R asterisk.asterisk /var/spool/asterisk
    fi

}


#Verificar si existen los archivos por defecto 
check_default


#Inicio reparando permisos de archivos
chown -R asterisk.asterisk /opt/asterisk/etc/asterisk
chown -R asterisk.asterisk /opt/asterisk/etc/asterisk/*
chown -R asterisk.asterisk /opt/asterisk/var/log/asterisk
chown -R asterisk.asterisk /opt/asterisk/var/log/asterisk/*
chown -R asterisk.asterisk /opt/asterisk/var/lib/asterisk
chown -R asterisk.asterisk /opt/asterisk/var/lib/asterisk/*
chown -R asterisk.asterisk /opt/asterisk/var/spool/asterisk/*
chown -R asterisk.asterisk /opt/asterisk/var/spool/asterisk
chown -R asterisk.asterisk /var/lib/asterisk/agi-bin/*
chmod +x /opt/asterisk/lib/asterisk/modules/*

for i in $(find /opt/asterisk/var/lib/asterisk/agi-bin -type f);do 
    chown asterisk.asterisk $i
    chmod +x $i
done


#Proceso principal
exec /usr/sbin/asterisk -f -U asterisk -G asterisk