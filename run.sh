#!/bin/bash -e

DOCKER_IMAGE_NAME="magnetikonline/nginx"
NGINX_CONF_DIR="/etc/nginx"
NGINX_DOCUMENT_ROOT="/srv/http"
NGINX_LOG_DIR="/var/log/nginx"


if [[ (! -f "$1/nginx.conf") || (! -d $2) ]]; then
	echo "Usage: $(basename $0) /path/to/nginx.conf /path/to/docroot"
	exit 1
fi

if [[ -z $3 ]]; then
	# run Nginx without logs to host
	docker run -d \
		-p 8080:80 \
		-p 8443:443 \
		-v $(readlink -f $1):$NGINX_CONF_DIR \
		-v $(readlink -f $2):$NGINX_DOCUMENT_ROOT \
		-w $NGINX_DOCUMENT_ROOT \
		$DOCKER_IMAGE_NAME

else
	if [[ ! -d $3 ]]; then
		echo "Usage: $(basename $0) /path/to/nginx.conf /path/to/docroot /path/to/logs"
		exit 1
	fi

	# run Nginx with logs passed to host
	docker run -d \
		-p 8080:80 \
		-p 8443:443 \
		-v $(readlink -f $1):$NGINX_CONF_DIR \
		-v $(readlink -f $2):$NGINX_DOCUMENT_ROOT \
		-v $(readlink -f $3):$NGINX_LOG_DIR \
		-w $NGINX_DOCUMENT_ROOT \
		$DOCKER_IMAGE_NAME
fi

# success
exit 0
