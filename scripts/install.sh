#!/bin/bash
TS3_URL="http://dl.4players.de/ts/releases/3.0.11.3/teamspeak3-server_linux-amd64-3.0.11.3.tar.gz"

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get -y install curl sudo
apt-get clean

curl -Ls "$TS3_URL" | tar zxf - -C /opt

chmod -R 700 /opt/
