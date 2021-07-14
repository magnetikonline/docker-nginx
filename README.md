# Docker Nginx

`Dockerfile` using Ubuntu 18.04 as base which provides:
- [Nginx 1.20.1](http://nginx.org/en/CHANGES-1.20) (compiled from source).
- Nginx configuration passed in from host file system.
- Logging within container at `/var/log/nginx` (optionally passed to host).
- Document root from host file system mounted within container at `/srv/http`.
- Ports `80` (HTTP) and `443` (HTTPS) exposed at `8080` and `8443` respectively.

## Usage

To build Docker image:

```sh
$ ./build.sh
```

Alternatively pull the image direct from Docker Hub:

```sh
$ docker pull magnetikonline/nginx
```

Then to run:

```sh
$ ./run.sh \
	-c /path/to/nginx.conf \
	-d /path/to/docroot
```

Or to additionally pass Nginx logs back to host:

```sh
$ ./run.sh \
	-c /path/to/nginx.conf \
	-d /path/to/docroot \
	-l /path/to/logs
```

An Nginx configuration example located under [resource/conf](resource/conf).
