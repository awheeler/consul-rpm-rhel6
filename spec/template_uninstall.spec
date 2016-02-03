#!/bin/bash

service consul-template stop
chkconfig --del consul-template

userdel -r consul-template 
