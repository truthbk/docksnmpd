FROM ubuntu:latest
MAINTAINER Jaime Fullaondo @truthbk
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update && apt-get install -y \
    curl \
    procps \
    fakeroot \
    file \
    git \
    build-essential

RUN curl -s -L -o /tmp/snmpd.tar.gz https://s3.amazonaws.com/dd-agent-tarball-mirror/net-snmp-5.7.3.tar.gz && \
    curl -s -L -o /tmp/snmpd.conf https://raw.githubusercontent.com/truthbk/docksnmpd/master/resources/snmpd.conf && \
    mkdir /tmp/snmpd && \
    mkdir /tmp/net-snmpd && \
    tar zxf /tmp/snmpd.tar.gz -C /tmp/snmpd --strip-components=1 && \
    cd /tmp/snmpd && yes '' | ./configure --disable-embedded-perl --without-perl-modules --prefix=/tmp/net-snmpd && \
    make && make install && cd -

# this should launch it.
ENTRYPOINT /tmp/net-snmpd/sbin/snmpd -f -Ln -c /tmp/snmpd.conf -x TCP:161 UDP:161 -p /tmp/snmpd.pid

