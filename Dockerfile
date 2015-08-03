FROM debian
MAINTAINER Chronos <chronos@procnull.de>

ADD /scripts/ /opt/scripts/
RUN chmod 777 /opt/scripts/install.sh; sleep 1; /opt/scripts/install.sh

# UID ZNC will run as; defaults to 65534 (nobody)
# Override at container creation time with "docker run --env UID_TS3=<NEW_UID>"
ENV         UID_TS3=65534

VOLUME ["/teamspeak3"]
ENTRYPOINT ["/opt/scripts/docker-ts3.sh"]

# Expose ts3 port, files and serverquery
EXPOSE 9987/udp 30033 10011
