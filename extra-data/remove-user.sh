#!/bin/bash

# Add an htpasswd
htpasswd -D /etc/apache2/.htpasswd $1
