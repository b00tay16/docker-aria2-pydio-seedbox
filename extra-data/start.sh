#!/bin/bash

# Let's encrypt HTTPS
# /lets-encrypt.sh

if [ -f /firststart ]; then

	if [ -z $RPC_SECRET ]; then
	  export RPC_SECRET=$(date +%s | sha256sum | base64 | head -c 32)
	fi

	if [ -z $FTP_PASSIVE_RANGE ]; then
	  export FTP_PASSIVE_RANGE="30000:30009"
	fi

	if [ -z $DOMAIN ]; then
	  export DOMAIN=$(wget -qO- ipinfo.io/ip)
	fi

	# Change rpc-password on aria2 webui and supervisor
	sed -i "s#RPC_SECRET#$RPC_SECRET#" /etc/supervisor/conf.d/supervisord.conf
	sed -i "s#RPC_SECRET#$RPC_SECRET#" /var/www/aria2-webui/configuration.js
	sed -i "s#DOMAIN#$DOMAIN#" /var/www/aria2-webui/configuration.js
	
	rm /firststart

fi

# Echo credentials
printf "\n#################"
printf "\n# Informations"
printf "\n#################"
printf "\nRPC_SECRET : $RPC_SECRET"
printf "\nDOMAIN     : $DOMAIN"
printf "\n#################\n\n"


# Fix rights on downloads folder
chown -R ftpuser:ftpgroup /downloads
chown -R ftpuser:ftpgroup /var/www

# Create aria2 session
touch /downloads/aria2.session

# Transform ftp db into pure-ftpd format
pure-pw mkdb

# Start supervisord
/usr/bin/supervisord
