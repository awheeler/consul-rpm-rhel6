#!/bin/bash

chkconfig --del consul > /dev/null 2>&1

userdel -r consul > /dev/null 2>&1
