#!/bin/bash

chkconfig --del consul

userdel -r consul
