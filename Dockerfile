FROM ubuntu:14.04.2
MAINTAINER Peter Mescalchin "peter@magnetikonline.com"

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install libpcre3-dev make zlib1g-dev
RUN apt-get clean

ADD http://nginx.org/download/nginx-1.6.2.tar.gz /root/build/
WORKDIR /root/build
RUN tar -xf nginx-1.6.2.tar.gz

ADD ./resource/configure.sh /root/build/nginx-1.6.2/
WORKDIR /root/build/nginx-1.6.2
RUN chmod a+x configure.sh
RUN ./configure.sh && make
RUN mkdir /usr/local/nginx && \
	cp /root/build/nginx-1.6.2/objs/nginx /usr/local/nginx

VOLUME ["/etc/nginx","/srv/http","/var/log/nginx"]

EXPOSE 80 443

CMD ["/usr/local/nginx/nginx"]
