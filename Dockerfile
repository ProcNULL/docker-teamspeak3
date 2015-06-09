###############################################
# Debian with added Teamspeak 3 Server. 
# Uses SQLite Database on default.
###############################################

# Using latest Debian image as base
FROM debian

MAINTAINER Chronos <chronos@procnull.de>

ADD /scripts/ /opt/scripts/
RUN chmod 777 /opt/scripts/install.sh && /opt/scripts/install.sh

# Inject a Volume for any TS3-Data that needs to be persisted or to be accessible from the host.
VOLUME ["/teamspeak3"]

USER nobody
ENTRYPOINT ["/opt/scripts/docker-ts3.sh"]

# Expose the Standard TS3 port.
EXPOSE 9987/udp
# for files
EXPOSE 30033 
# for ServerQuery
EXPOSE 10011
