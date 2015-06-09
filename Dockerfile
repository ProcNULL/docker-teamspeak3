###############################################
# Debian with added Teamspeak 3 Server. 
# Uses SQLite Database on default.
###############################################

# Using latest Debian image as base
FROM debian

MAINTAINER Chronos <chronos@procnull.de>

# Download Link of TS3 Server
ENV TEAMSPEAK_URL http://dl.4players.de/ts/releases/3.0.11.2/teamspeak3-server_linux-amd64-3.0.11.2.tar.gz

# Download TS3 file and extract it into /opt.
ADD ${TEAMSPEAK_URL} /opt/
RUN cd /opt && tar -xzf /opt/teamspeak3-server_linux-amd64-3*.tar.gz

ADD /scripts/ /opt/scripts/
RUN chown -R nobody /opt/scripts/; chmod -R 774 /opt/scripts/

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
