FROM debian:jessie

ENV MOSQUITTO_VERSION=1.4.14

RUN \
        set -x; \
        apt-get update && apt-get install -y --no-install-recommends \
                libc-ares-dev git libmysqlclient-dev libssl-dev   uuid-dev build-essential wget  ca-certificates \
                curl libcurl4-openssl-dev  libc-ares2 libcurl3 \
        && cd /tmp \
        && wget http://mosquitto.org/files/source/mosquitto-$MOSQUITTO_VERSION.tar.gz -O mosquitto.tar.gz \
        && mkdir mosquitto-src && tar xfz mosquitto.tar.gz --strip-components=1 -C mosquitto-src \
        && cd mosquitto-src \
        && make WITH_SRV=yes WITH_MEMORY_TRACKING=no \
        && make install && ldconfig \
        && git clone https://github.com/jpmens/mosquitto-auth-plug.git \
        && cd mosquitto-auth-plug \
        && cp config.mk.in config.mk \
        && sed -i "s/BACKEND_HTTP ?= no/BACKEND_HTTP ?= yes/" config.mk \
        && sed -i "s/BACKEND_MYSQL ?= yes/BACKEND_MYSQL ?= no/" config.mk \
        && sed -i "s/CFG_LDFLAGS =/CFG_LDFLAGS = -lcares/" config.mk \
        && sed -i "s/MOSQUITTO_SRC =/MOSQUITTO_SRC = \/tmp\/mosquitto-src\//" config.mk \
        && make \
        && cp np /usr/bin/np \
        && mkdir /mqtt && cp auth-plug.so /mqtt/ \
        && cp auth-plug.so /usr/local/lib/ \
        && useradd -r mosquitto \
        && apt-get purge -y build-essential git wget ca-certificates \
        && apt-get autoremove -y \
        && rm -rf  /tmp/*

RUN mkdir -p /aws && \
    apt-get -y install python-pip && \
    pip install awscli && \
    apt-get remove -y --purge python-pip && \
	apt-get -y autoclean && \
    rm -rf /var/cache/apt/*
	


ADD mosquitto.conf /etc/mosquitto/mosquitto.conf
ADD configure.sh /configure.sh
ADD run.sh /run.sh
RUN apt-get -y install dos2unix
RUN dos2unix /configure.sh /run.sh  /etc/mosquitto/mosquitto.conf && \
    chmod +x /configure.sh /run.sh


VOLUME ["/var/lib/mosquitto"]

EXPOSE 1883 8883

CMD /configure.sh && /run.sh mosquittoverbose
