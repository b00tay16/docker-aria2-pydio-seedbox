#!/bin/bash

# Let's encrypt HTTPS
# /lets-encrypt.sh


if [ -z $RPC_SECRET ]; then
  export RPC_SECRET=$(date +%s | sha256sum | base64 | head -c 32)
fi

if [ -z $FTP_PASSIVE_RANGE ]; then
  export FTP_PASSIVE_RANGE="30000:30009"
fi

if [ -z $DOMAIN ]; then
  export DOMAIN=$(wget -qO- ipinfo.io/ip)
fi

# Copy conf files
cp -r /var/www/aria2-webui/configuration.js_bak /var/www/aria2-webui/configuration.js

# Create aria2 configuration folder
mkdir -p /downloads/aria2-configuration

# Copy aria2 config
if [ ! -f /downloads/aria2-configuration/aria2.conf ]; then
    cp -r /aria2.conf_bak /downloads/aria2-configuration/aria2.conf
fi

# Copy aria2 session
if [ ! -f /downloads/aria2-configuration/aria2.session ]; then
    touch /downloads/aria2-configuration/aria2.session
fi

# Change rpc-password on aria2 webui and supervisor
sed -i "s#RPC_SECRET#$RPC_SECRET#" /var/www/aria2-webui/configuration.js
sed -i "s#DOMAIN#$DOMAIN#" /var/www/aria2-webui/configuration.js
	

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

# Transform ftp db into pure-ftpd format
pure-pw mkdb

# Start supervisord
/usr/bin/supervisord
