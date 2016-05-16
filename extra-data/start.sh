#!/bin/bash

# Let's encrypt HTTPS
/lets-encrypt.sh

if [ -z $DOMAIN ]; then
  export DOMAIN=$(wget -qO- ipinfo.io/ip)
fi

if [ -z $RPC_SECRET ]; then
  export RPC_SECRET=$(date +%s | sha256sum | base64 | head -c 32)
fi

# Change rpc-password on aria2 webui
sed -i "s#RPC_SECRET#$RPC_SECRET#" /var/www/aria2-webui/configuration.js
sed -i "s#DOMAIN#$DOMAIN#" /var/www/aria2-webui/configuration.js

# Echo credentials
cat <<EOF


#################
# Informations
#################

RPC_SECRET : $RPC_SECRET
DOMAIN     : $DOMAIN

#################


EOF

# Fix rights on downloads folder
chown -R ftpuser:ftpgroup /downloads
chown -R ftpuser:ftpgroup /var/www

# Transform ftp db into pure-ftpd format
pure-pw mkdb

# Start supervisord
/usr/bin/supervisord
