#!/bin/bash

service consul stop
chkconfig --del consul

userdel -r consul
