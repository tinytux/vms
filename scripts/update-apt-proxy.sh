#!/bin/bash
#
# update apt proxy
#

if [ $(id -u) != 0 ]; then
    echo "ERROR: $0 must be be run as root, not as `whoami`" 2>&1
    exit 1
fi

DEBIAN_FRONTEND=noninteractive

if [[ ! -n "$(grep  "Acquire::http::Proxy" /etc/apt/apt.conf)" ]]; then
    echo "No apt proxy detected."
else
    DEFAULT_GATEWAY=$(ip route | grep "default via " | cut -d ' ' -f 3)
    echo "Updating apt proxy: ${DEFAULT_GATEWAY}:3142"
    sed -r 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}:3142\b'/${DEFAULT_GATEWAY}:3142/ -i /etc/apt/apt.conf
fi


