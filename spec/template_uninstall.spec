#!/bin/bash

service consul-template stop > /dev/null 2>&1
chkconfig --del consul-template > /dev/null 2>&1

userdel -r consul-template > /dev/null 2>&1
