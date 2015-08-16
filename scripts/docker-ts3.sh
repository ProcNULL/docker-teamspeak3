#!/bin/bash
VOLUME=/teamspeak3

[ -n "$UID" ] || UID=65534
if ! [ "$UID" -eq "$UID" ]; then
  echo "\$UID is _NOT_ valid! Exiting!"
  exit -1
fi

ts3files_chown() {
  echo "Chowning..."
  chown -R $UID /teamspeak3
  chown -R $UID /opt/
  chmod -R u+x /opt/
}

start_ts3srv_createini() {
  ts3files_chown
  echo "  ====> start_ts3srv_createini"
  sudo -u \#$UID /opt/teamspeak3-server_linux-amd64/ts3server_minimal_runscript.sh \
    query_ip_whitelist="/teamspeak3/query_ip_whitelist.txt" \
    query_ip_blacklist="/teamspeak3/query_ip_blacklist.txt" \
    logpath="/teamspeak3/logs/" \
    licensepath="/teamspeak3/" \
    inifile="/teamspeak3/ts3server.ini" \
    createinifile=1
}

start_ts3srv() {
  ts3files_chown
  echo "  ====> start_ts3srv"
  sudo -u \#$UID /opt/teamspeak3-server_linux-amd64/ts3server_minimal_runscript.sh \
    inifile="/teamspeak3/ts3server.ini"  
}

start_ts3srv_auto() {
  echo "  ====> start_ts3srv_auto"
  if [ -f $VOLUME/ts3server.ini ]
  then
    start_ts3srv
  else
    start_ts3srv_createini
  fi
}

echo "========================================================================="
echo "  Please don't get confused by f***ed up 'docker logs' output.           "
echo "  We have no clue why this happens, but everything seems to be alright.  "
echo "========================================================================="

# Link the files-folder into the host-mounted volume
mkdir -p /teamspeak3/files
if ! [ -L /opt/teamspeak3-server_linux-amd64/files ]
then
  echo "Linking the files-folder into the host-mounted volume."
  rm -rf /opt/teamspeak3-server_linux-amd64/files
  ln -s /teamspeak3/files /opt/teamspeak3-server_linux-amd64/files
fi

# Check if ts3server.sqlitedb exists in host-mounted volume, if yes, symlink it; if no,, create it
if [ -f $VOLUME/ts3server.sqlitedb ] && ! [ -L /opt/teamspeak3-server_linux-amd64/ts3server.sqlitedb ]
then
  echo "VOLUME/ts3server.sqlitedb found. Creating Link between VOLUME db-file and TS3 dir."
  rm /opt/teamspeak3-server_linux-amd64/ts3server.sqlitedb
  ln -s $VOLUME/ts3server.sqlitedb /opt/teamspeak3-server_linux-amd64/ts3server.sqlitedb

  start_ts3srv_auto
else
  start_ts3srv_auto &
  sleep 10
  TS3_PID=$(pgrep "ts3server_linux")
  kill $TS3_PID
  sleep 5

  mv /opt/teamspeak3-server_linux-amd64/ts3server.sqlitedb $VOLUME/ts3server.sqlitedb
  ln -s $VOLUME/ts3server.sqlitedb /opt/teamspeak3-server_linux-amd64/ts3server.sqlitedb

  start_ts3srv
fi
