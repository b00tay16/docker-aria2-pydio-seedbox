#!/bin/bash

# Add an htpasswd
htpasswd -c /etc/apache2/.htpasswd $1
