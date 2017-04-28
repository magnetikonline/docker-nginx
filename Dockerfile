FROM ubuntu:16.04
MAINTAINER Peter Mescalchin <peter@magnetikonline.com>

ENV VERSION 1.12.0

RUN apt-get update && apt-get -y upgrade && \
	apt-get -y install gcc libpcre3-dev make zlib1g-dev && \
	apt-get clean

ADD http://nginx.org/download/nginx-$VERSION.tar.gz /root/build/
WORKDIR /root/build
RUN tar -xf nginx-$VERSION.tar.gz

ADD ./resource/configure.sh /root/build/nginx-$VERSION/
WORKDIR /root/build/nginx-$VERSION
RUN chmod u+x configure.sh
RUN ./configure.sh && make

RUN mkdir -p /usr/local/nginx && \
	cp /root/build/nginx-$VERSION/objs/nginx /usr/local/nginx

VOLUME ["/etc/nginx","/srv/http","/var/log/nginx"]

EXPOSE 80 443

CMD ["/usr/local/nginx/nginx"]
