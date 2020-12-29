FROM	nsoporte/asterisk:latest



COPY	agi-bin/nsoporte /opt/asterisk/samples/asterisk-lib/agi-bin



RUN		apt-get update; apt-get -y upgrade; \
		apt-get -y install php-cli



RUN		rm -rf /opt/asterisk/lib/asterisk/modules/app_queue.so; \
		rm -rf /opt/asterisk/lib/asterisk/modules/codec_g729a.so; \
		rm -rf /opt/asterisk/lib/asterisk/modules/cdr_*; \
		rm -rf /opt/asterisk/lib/asterisk/modules/cel_*; \
		rm -rf /opt/asterisk/lib/asterisk/modules/res_pjsip*; \
		rm -rf /opt/asterisk/lib/asterisk/modules/res_odbc.so; \
		rm -rf /opt/asterisk/lib/asterisk/modules/res_config_mysql.so; \
		rm -rf /opt/asterisk/lib/asterisk/modules/res_config_sqlite3.so; \
		rm -rf /opt/asterisk/lib/asterisk/modules/res_config_odbc.so; \
		rm -rf /opt/asterisk/lib/asterisk/modules/cdr; \
		rm -rf /opt/asterisk/lib/asterisk/modules/chan_sip.so; \
		rm -rf /opt/asterisk/lib/asterisk/modules/res_fax*; \
		rm -rf /opt/asterisk/lib/asterisk/modules/chan_ooh323.so



VOLUME 	[ "/opt/asterisk/etc/asterisk", "/opt/asterisk/var/lib/asterisk", "/opt/asterisk/var/spool/asterisk", "/var/log/asterisk" ]

