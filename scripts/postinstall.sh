#!/bin/bash
#
# First script called after initial installation of the OS.
#

if [ $(id -u) != 0 ]; then
    echo "ERROR: $0 must be be run as root" 2>&1
    exit 1
fi

apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade


