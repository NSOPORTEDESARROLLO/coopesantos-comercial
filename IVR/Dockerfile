FROM	nsoporte/asterisk:latest



COPY	agi-bin/nsoporte /opt/asterisk/samples/asterisk-lib/agi-bin



RUN		apt-get update; apt-get -y upgrade; \
		apt-get -y install php-cli



RUN		cp -rf /opt/asterisk/samples/asterisk-lib/* /opt/asterisk/var/lib/asterisk/; \
		rm -rf  /opt/asterisk/var/lib/asterisk/sounds/*; \
		chown -R asterisk.asterisk /opt/asterisk/var/lib/asterisk




VOLUME 	[ "/opt/asterisk/etc/asterisk", "/opt/asterisk/var/lib/asterisk/sounds", "/opt/asterisk/var/spool/asterisk", "/var/log/asterisk" ]

