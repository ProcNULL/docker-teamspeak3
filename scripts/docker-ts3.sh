#!/bin/bash
VOLUME=/teamspeak3
[ -n $TS_UID ] || TS_UID=65534

echo " ----- docker-ts3 ------"
echo "1. Check if we have a ts3server.sqlitedb to be moved to the host-mounted volume."
if [ -f /opt/teamspeak3-server_linux-amd64/ts3server.sqlitedb ] && ! [ -f $VOLUME/ts3server.sqlitedb ]
then
  echo "ts3server.sqlitedb found. Moving to host-mounted volume."
  mv /opt/teamspeak3-server_linux-amd64/ts3server.sqlitedb $VOLUME/ts3server.sqlitedb
fi

echo "2. Check if ts3server.sqlitedb exists in host-mounted volume."
if [ -f $VOLUME/ts3server.sqlitedb ] && ! [ -L /opt/teamspeak3-server_linux-amd64/ts3server.sqlitedb ]
then
  echo "$VOLUME/ts3server.sqlitedb found. Creating Link between host-mounted db-file and ts3-folder."
  rm /opt/teamspeak3-server_linux-amd64/ts3server.sqlitedb
  ln -s $VOLUME/ts3server.sqlitedb /opt/teamspeak3-server_linux-amd64/ts3server.sqlitedb 
fi

echo "3. Link the files-folder into the host-mounted volume."
mkdir -p /teamspeak3/files
if ! [ -L /opt/teamspeak3-server_linux-amd64/files ]
then
  rm -rf /opt/teamspeak3-server_linux-amd64/files
  ln -s /teamspeak3/files /opt/teamspeak3-server_linux-amd64/files
fi

echo "4. Make sure that $TS_UID owns everything in /teamspeak3 and /opt/teamspeak3-server_linux-amd64."
chown -R $TS_UID /teamspeak3
chown -R $TS_UID /opt/teamspeak3-server_linux-amd64

echo "5. Starting TS3-Server."
echo "Check if ts3server.ini exists in host-mounted volume."
if [ -f $VOLUME/ts3server.ini ]
then
  echo "$VOLUME/ts3server.ini found. Using ini as config file."
  echo "HINT: If this ini was transfered from another ts3-install you may want to make sure the following settings are active for the usage of host-mounted volume: (OPTIONAL)"
  echo "query_ip_whitelist='/teamspeak3/query_ip_whitelist.txt'"
  echo "query_ip_backlist='/teamspeak3/query_ip_blacklist.txt'"
  echo "logpath='/teamspeak3/logs/'"
  echo "licensepath='/teamspeak3/'"
  echo "inifile='/teamspeak3/ts3server.ini'"
  sudo -u $TS_UID /opt/teamspeak3-server_linux-amd64/ts3server_minimal_runscript.sh \
    inifile="/teamspeak3/ts3server.ini"
else
  echo "$VOLUME/ts3server.ini not found. Telling TS3 to create new config file."
  sudo -u $TS_UID /opt/teamspeak3-server_linux-amd64/ts3server_minimal_runscript.sh \
    query_ip_whitelist="/teamspeak3/query_ip_whitelist.txt" \
    query_ip_backlist="/teamspeak3/query_ip_blacklist.txt" \
    logpath="/teamspeak3/logs/" \
    licensepath="/teamspeak3/" \
    inifile="/teamspeak3/ts3server.ini" \
    createinifile=1
fi
