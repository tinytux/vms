#!/bin/bash
#
# First script called after initial installation of the OS.
#

if [ $(id -u) != 0 ]; then
    echo "ERROR: $0 must be be run as root, not as `whoami`" 2>&1
    exit 1
fi

echo "Updating the system, this takes some time..."
apt-get -y update >/dev/null
apt-get -y upgrade >/dev/null
apt-get -y dist-upgrade >/dev/null


