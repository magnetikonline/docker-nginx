#!/bin/bash

NGINX_CONF_DIR="/etc/nginx"
NGINX_DOCUMENT_ROOT="/srv/http"
NGINX_LOG_DIR="/var/log/nginx"


if [ ! -f "$1/nginx.conf" ] || [ ! -d "$2" ]; then
	echo "Usage: $(basename $0) /path/to/nginx.conf /path/to/docroot"
	exit
fi

if [ -z "$3" ]; then
	# run Nginx without logs to host
	sudo docker run -d \
		-p 8080:80 \
		-p 8443:443 \
		-v $(readlink -f $1):$NGINX_CONF_DIR \
		-v $(readlink -f $2):$NGINX_DOCUMENT_ROOT \
		-w $NGINX_DOCUMENT_ROOT \
		magnetikonline/nginx

else
	if [ ! -d "$3" ]; then
		echo "Usage: $(basename $0) /path/to/nginx.conf /path/to/docroot /path/to/logs"
		exit
	fi

	# run Nginx with logs passed to host
	sudo docker run -d \
		-p 8080:80 \
		-p 8443:443 \
		-v $(readlink -f $1):$NGINX_CONF_DIR \
		-v $(readlink -f $2):$NGINX_DOCUMENT_ROOT \
		-v $(readlink -f $3):$NGINX_LOG_DIR \
		-w $NGINX_DOCUMENT_ROOT \
		magnetikonline/nginx
fi
