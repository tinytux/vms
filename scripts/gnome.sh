#!/bin/bash
#
# Minimal GNOME installation
#

if [ $(id -u) != 0 ]; then
    echo "ERROR: $0 must be be run as root, not as `whoami`" 2>&1
    exit 1
fi

apt-get -y install slim gnome-common 


