FROM 	debian:buster-slim


ADD		files/webmin.tgz /usr/share
ADD		files/webmin-etc.tgz /data/apps/webmin
ADD		files/ns-start /usr/bin

RUN 	apt-get update; apt-get -y upgrade; \
		apt-get -y install perl libnet-ssleay-perl openssl \
		libauthen-pam-perl libpam-runtime libio-pty-perl \ 
		python unzip shared-mime-info wget ffmpeg procps; \ 
		rm /etc/apt/apt.conf.d/docker-gzip-indexes; \
		rm /var/lib/apt/lists/*lz4; \
		apt-get -o Acquire::GzipIndexes=false update; \
		apt-get -y install apt-show-versions


RUN 	tar -czvf /opt/webmin-etc.tgz /data/apps/webmin/etc; \
		rm -rf  /data/apps/webmin/etc; \
		chmod +x /usr/bin/ns-start



CMD 	[ "/usr/bin/ns-start" ]

