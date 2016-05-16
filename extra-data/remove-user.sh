#!/bin/bash

# Add an htpasswd
pure-pw userdel $1
pure-pw mkdb
chmod 644 /etc/pure-ftpd/pureftpd.passwd
