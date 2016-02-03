#!/bin/bash

chmod +x /usr/bin/consul-template
chmod +x /etc/init.d/consul-template

mkdir -p /var/lib/consul-template > /dev/null 2>&1
mkdir -p /etc/consul-template/template > /dev/null 2>&1

useradd -r -g consul-template -d /var/lib/consul-template -s /sbin/nologin -c "consul.io template user" consul-template
chown consul-template:consul-template /var/lib/consul-template/ > /dev/null 2>&1

chkconfig --add consul-template > /dev/null 2>&1
