#!/bin/bash -e

DIRNAME=$(dirname "$0")
DOCKER_REPOSITORY=${DOCKER_REPOSITORY-"magnetikonline/nginx"}


. "$DIRNAME/version"

docker build \
	--build-arg "NGINX_VERSION=$NGINX_VERSION" \
	--tag "$DOCKER_REPOSITORY:$NGINX_VERSION" \
		"$DIRNAME"
