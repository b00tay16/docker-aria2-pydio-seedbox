#!/bin/bash

# Add an htpasswd
htpasswd -b -c /etc/apache2/.htpasswd $1
