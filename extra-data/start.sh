#!/bin/bash

# Let's encrypt HTTPS
/lets-encrypt.sh

# Change rpc-password on aria2 webui
sed -i "s#YOUR_SECRET_TOKEN#$RPC_SECRET#" /var/www/aria2-webui/configuration.js

# Start supervisord
/usr/bin/supervisord
