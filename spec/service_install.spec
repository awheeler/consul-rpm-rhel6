#!/bin/bash

useradd -r -d /var/lib/consul -s /sbin/nologin -c "consul.io user" consul
mkdir -p /var/lib/consul
chown consul:consul /var/lib/consul/
chkconfig --add consul
