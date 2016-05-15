#!/bin/bash

# Let's encrypt HTTPS
/lets-encrypt.sh

# Change rpc-password on aria2 webui
sed -i "s#RPC_SECRET#$RPC_SECRET#" /var/www/aria2-webui/configuration.js
sed -i "s#DOMAIN#$DOMAIN#" /var/www/aria2-webui/configuration.js

# Start supervisord
/usr/bin/supervisord
