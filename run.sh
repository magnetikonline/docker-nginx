#!/bin/bash -e

DOCKER_IMAGE_NAME="magnetikonline/nginx"
NGINX_CONF_DIR="/etc/nginx"
NGINX_DOCUMENT_ROOT_DIR="/srv/http"
NGINX_LOG_DIR="/var/log/nginx"


function exitError {

	echo "Error: $1" >&2
	exit 1
}

function getPathCanonical {

	readlink -en "$1" || true
}

function usage {

	cat <<EOM
Usage: $(basename "$0") [OPTION]...

  -c DIR    path to Nginx config mounted inside container at $NGINX_CONF_DIR
  -d DIR    document root mounted at $NGINX_DOCUMENT_ROOT_DIR
  -l DIR    optional path for Nginx logs back to host, mounted at $NGINX_LOG_DIR
  -h        display help
EOM

	exit 2
}

# read arguments
hostNginxConfDir=""
hostNginxDocumentRootDir=""
hostNginxLogDir=""
while getopts ":c:d:l:h" optKey; do
	case $optKey in
		c)
			hostNginxConfDir=$OPTARG
			;;
		d)
			hostNginxDocumentRootDir=$OPTARG
			;;
		l)
			hostNginxLogDir=$OPTARG
			;;
		h|*)
			usage
			;;
	esac
done

# verify paths
if [[ -z $hostNginxConfDir ]]; then
	exitError "No host path to Nginx config given"
fi

if [[ ! -d $hostNginxConfDir ]]; then
	exitError "Invalid host path to Nginx config of [$hostNginxConfDir]"
fi

if [[ ! -f "$hostNginxConfDir/nginx.conf" ]]; then
	exitError "Unable to locate nginx.conf at [$hostNginxConfDir/nginx.conf]"
fi

if [[ -z $hostNginxDocumentRootDir ]]; then
	exitError "No path to Nginx document root given"
fi

if [[ ! -d $hostNginxDocumentRootDir ]]; then
	exitError "Invalid Nginx document root of [$hostNginxDocumentRootDir]"
fi

if [[ (-n $hostNginxLogDir) && (! -d $hostNginxLogDir) ]]; then
	exitError "Invalid host path for Nginx log files of [$hostNginxLogDir]"
fi

# run Nginx Docker image
if [[ -z $hostNginxLogDir ]]; then
	# without mapping logs to host
	docker run \
		--detach \
		--publish 8080:80 \
		--publish 8443:443 \
		--volume "$(getPathCanonical "$hostNginxConfDir"):$NGINX_CONF_DIR" \
		--volume "$(getPathCanonical "$hostNginxDocumentRootDir"):$NGINX_DOCUMENT_ROOT_DIR" \
		--workdir "$NGINX_DOCUMENT_ROOT_DIR" \
		$DOCKER_IMAGE_NAME

else
	# Nginx logs mapped back to host
	docker run \
		--detach \
		--publish 8080:80 \
		--publish 8443:443 \
		--volume "$(getPathCanonical "$hostNginxConfDir"):$NGINX_CONF_DIR" \
		--volume "$(getPathCanonical "$hostNginxDocumentRootDir"):$NGINX_DOCUMENT_ROOT_DIR" \
		--volume "$(getPathCanonical "$hostNginxLogDir"):$NGINX_LOG_DIR" \
		--workdir "$NGINX_DOCUMENT_ROOT_DIR" \
		$DOCKER_IMAGE_NAME
fi

# success
exit 0
