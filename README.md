### docker-teamspeak3

Debian with TS3 Server.
Fork of luzifer-docker/docker-teamspeak3

#### Summary
* Debian
* Teamspeak 3 Server
* Some files are accessible from the host:
  * query_ip_whitelist.txt
  * query_ip_blacklist.txt
  * logs
  * files
  * ts3server.sqlitedb 
  * licence (Not tested)
  * ts3server.ini
  * **IMPORTANT**: User nobody (uid=65534) needs access to those files (and the conteining folder) because TS3 is running as nobody.

#### Usage
  * Infos
  
	The script does look for an sqlite db in the linked host-folder. 
	If its found, a symlink is created to the ts3-folder inside the container. 
	This means the server should use your old ts3 db if present. 
	If not present it will create a new one and move it to the host-folder AFTER A RESTART!
	
	Script will also look for ts3server.ini in linked host-folder. This file will also be created if its not 
	found since TS3-server has a paramater for that. If you use your own ini-file you may want to link logs and other data to /teamspeak3.

  * Build container (optional)
  
	Just in case you dont wanna use the index.
	
    `sudo docker build -t procnull/docker-teamspeak3 https://github.com/ProcNULL/docker-teamspeak3.git` 
  
  
  * Create container
    
    This creates and starts a docker container in the 
    background (-d) with 
    direct mapping of the TS3 port (-p 9987:9987/udp)
    and sets the name to TS3.
    {FOLDER} is an absolute path on the host to be mapped by the containers /teamspeak3 folder.
    Injected files are used from this location, see Summary above.
    Again: Make sure that "nobody" (uid=65534) has r/w-access to this folder and its contents.

    `sudo docker run --name TS3 -d -p 9987:9987/udp -v {FOLDER}:/teamspeak3 procnull/docker-teamspeak3` 
    
  * Admin Secret
  
    After starting the container you probably want to get the Admin secret with:
    `sudo docker logs TS3` 

  * Restart

    You need to restart the conteiner once if you don't use an old ts3server.sqlitedb
    `sudo docker restart TS3`
    
  * Upgrading
  
    Just stop and remove the old container, then start again at "Creating container". You may have to pull the image again       if its not updating.
    CAUTION: Didnt test if all files are really persisted or if the TS3 process overwrites some files. So make sure you have a backup. 
