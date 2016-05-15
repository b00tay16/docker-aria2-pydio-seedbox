#!/bin/bash

# Let's encrypt HTTPS
if [[ $DOMAIN && $EMAIL ]]; then
  echo "Create lets encrypt certificate"
  cd /opt/letsencrypt

  LETS_ENCRYPT="./letsencrypt-auto --agree-tos --text --apache --renew-by-default -d ${DOMAIN} --email ${EMAIL}"

  echo "1" | $LETS_ENCRYPT
fi
