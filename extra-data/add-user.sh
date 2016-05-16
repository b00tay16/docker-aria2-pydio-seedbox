#!/bin/bash

# Add an htpasswd
pure-pw useradd $1 -u ftpuser -g ftpgroup -d /downloads
pure-pw mkdb
chmod 644 /etc/pure-ftpd/pureftpd.passwd
