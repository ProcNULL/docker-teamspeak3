#!/bin/bash
TS3_URL="http://dl.4players.de/ts/releases/3.0.11.2/teamspeak3-server_linux-amd64-3.0.11.2.tar.gz"
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get dist-upgrade
apt-get install curl
apt-get clean

curl -Ls "$TS_URL" | tar zxf - -C /opt

chown -R nobody /opt/
chmod -R 700 /opt/
