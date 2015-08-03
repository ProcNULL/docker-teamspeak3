FROM debian
MAINTAINER Chronos <chronos@procnull.de>

ADD /scripts/ /opt/scripts/
RUN chmod 777 /opt/scripts/install.sh; sleep 1; /opt/scripts/install.sh

VOLUME ["/teamspeak3"]

ENTRYPOINT ["/opt/scripts/docker-ts3.sh"]

# Expose ts3 port, files and serverquery
EXPOSE 9987/udp 30033 10011
