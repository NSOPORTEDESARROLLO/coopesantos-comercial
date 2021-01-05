FROM	nsoporte/asterisk:latest




RUN		apt-get update; apt-get -y upgrade; \
		apt-get -y install libasterisk-agi-perl libdbd-odbc-perl curl
		





RUN		cp -rf /opt/asterisk/samples/asterisk-lib/* /opt/asterisk/var/lib/asterisk/; \
		rm -rf  /opt/asterisk/var/lib/asterisk/sounds/*; \
		chown -R asterisk.asterisk /opt/asterisk/var/lib/asterisk; \
		chmod +x /opt/asterisk/var/lib/asterisk/agi-bin/*; \
		chmod +x /usr/bin/ns-start



VOLUME 	[ "/opt/asterisk/etc/asterisk", "/opt/asterisk/var/lib/asterisk/sounds", "/opt/asterisk/var/spool/asterisk", "/var/log/asterisk" ]

