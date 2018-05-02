# Docker Nginx
`Dockerfile` using Ubuntu 16.04 as base which provides:
- [Nginx 1.14.0](https://nginx.org/en/CHANGES-1.14) (compiled from source).
- Host file system served Nginx config.
- Logging within container at `/var/log/nginx` (optionally passed back to host).
- Document root from host file system mounted within container at `/srv/http`.
- Ports `80` (HTTP) and `443` (HTTPS) exposed to host at `8080` / `8443` respectively.

## Usage
To build Docker image:

```sh
$ ./build.sh
```

Alternatively pull the image from Docker Hub:

```sh
$ docker pull magnetikonline/nginx
```

Then to run:

```sh
$ ./run.sh \
	-c /path/to/nginx.conf \
	-d /path/to/docroot
```

To pass Nginx logs back to host:

```sh
$ ./run.sh \
	-c /path/to/nginx.conf \
	-d /path/to/docroot \
	-l /path/to/logs
```

An Nginx configuration example located under [resource/conf](resource/conf).
