#!/bin/bash

useradd -r -g consul -d /var/lib/consul -s /sbin/nologin -c "consul.io user" consul
mkdir -p /var/lib/consul > /dev/null 2>&1
chown consul:consul /var/lib/consul/ > /dev/null 2>&1
chkconfig --add consul > /dev/null 2>&1
