FROM ubuntu:14.04.4
MAINTAINER Peter Mescalchin <peter@magnetikonline.com>

RUN apt-get update && \
	apt-get -y upgrade && \
	apt-get -y install libpcre3-dev make zlib1g-dev && \
	apt-get clean

ADD http://nginx.org/download/nginx-1.10.0.tar.gz /root/build/
WORKDIR /root/build
RUN tar -xf nginx-1.10.0.tar.gz

ADD ./resource/configure.sh /root/build/nginx-1.10.0/
WORKDIR /root/build/nginx-1.10.0
RUN chmod a+x configure.sh
RUN ./configure.sh && make
RUN mkdir -p /usr/local/nginx && \
	cp /root/build/nginx-1.10.0/objs/nginx /usr/local/nginx

VOLUME ["/etc/nginx","/srv/http","/var/log/nginx"]

EXPOSE 80 443

CMD ["/usr/local/nginx/nginx"]
