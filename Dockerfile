###############################################
# Debian with added Teamspeak 3 Server. 
# Uses SQLite Database on default.
###############################################

# Using latest Debian image as base
FROM debian

MAINTAINER Chronos <chronos@procnull.de>

## Set some variables for override.
# Download Link of TS3 Server
ENV TEAMSPEAK_URL http://dl.4players.de/ts/releases/3.0.11.2/teamspeak3-server_linux-amd64-3.0.11.2.tar.gz

# Inject a Volume for any TS3-Data that needs to be persisted or to be accessible from the host. (e.g. for Backups)
VOLUME ["/teamspeak3"]

# Download TS3 file and extract it into /opt.
ADD ${TEAMSPEAK_URL} /opt/
RUN cd /opt && tar -xzf /opt/teamspeak3-server_linux-amd64-3*.tar.gz

ADD /scripts/ /opt/scripts/
RUN chmod -R 774 /opt/scripts/

ENTRYPOINT ["/opt/scripts/docker-ts3.sh"]

# Expose the Standard TS3 port.
EXPOSE 9987/udp
# for files
EXPOSE 30033 
# for ServerQuery
EXPOSE 10011
