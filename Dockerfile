FROM ubuntu:18.04 AS build

ENV VERSION "1.16.0"

RUN apt-get update && apt-get upgrade --yes && \
	apt-get install --yes gcc libpcre3-dev make zlib1g-dev

ADD "https://nginx.org/download/nginx-$VERSION.tar.gz" /root/build/
RUN tar \
	--directory /root/build \
	--extract \
	--file "/root/build/nginx-$VERSION.tar.gz"

WORKDIR "/root/build/nginx-$VERSION"
ADD ./resource/configure.sh .

RUN chmod u+x configure.sh
RUN ./configure.sh && \
	make install


FROM ubuntu:18.04
LABEL maintainer="Peter Mescalchin <peter@magnetikonline.com>"

COPY --from=build /usr/local/sbin/nginx /usr/local/sbin/nginx
RUN mkdir /usr/local/nginx
VOLUME ["/etc/nginx","/srv/http","/var/log/nginx"]

EXPOSE 80 443

CMD ["/usr/local/sbin/nginx","-g","daemon off;lock_file /run/lock/nginx.lock;"]
