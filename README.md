# Docker Nginx
Nginx `Dockerfile` using Ubuntu 14.04.4 as base which provides:
- [Nginx 1.10.0](http://nginx.org/en/CHANGES-1.10) (compiled from source).
- Host file system served Nginx config.
- Logging within container at `/var/log/nginx` (optionally passed back to host).
- Document root from host file system mounted within container at `/srv/http`.
- Ports `80` (HTTP) and `443` (HTTPS) exposed to host at `8080` / `8443` respectively.

## Usage
To build Docker image then run:

```sh
$ ./build.sh
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

Usable Nginx configuration example located under [resource/conf](resource/conf).
