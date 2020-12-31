FROM	nsoporte/asterisk:latest




RUN		apt-get update; apt-get -y upgrade; \
		apt-get -y install libasterisk-agi-perl curl; \
		curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -; \
		curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list; \
		apt-get update; \
		ACCEPT_EULA=Y apt-get -y install msodbcsql17; \
		ACCEPT_EULA=Y apt-get -y install mssql-tools




COPY	files/agi /opt/asterisk/samples/asterisk-lib/agi-bin
COPY 	files/ssl/openssl.cnf /etc/ssl/openssl.cnf




RUN		cp -rf /opt/asterisk/samples/asterisk-lib/* /opt/asterisk/var/lib/asterisk/; \
		rm -rf  /opt/asterisk/var/lib/asterisk/sounds/*; \
		chown -R asterisk.asterisk /opt/asterisk/var/lib/asterisk; \
		chmod +x /opt/asterisk/var/lib/asterisk/agi-bin/*




VOLUME 	[ "/opt/asterisk/etc/asterisk", "/opt/asterisk/var/lib/asterisk/sounds", "/opt/asterisk/var/spool/asterisk", "/var/log/asterisk" ]

