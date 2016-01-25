#!/bin/bash

useradd -M consul > /dev/null 2>&1
mkdir -p /var/lib/consul > /dev/null 2>&1
chown consul:consul /var/lib/consul/ > /dev/null 2>&1
chkconfig --add consul > /dev/null 2>&1
