#!/bin/bash
#
# Install openjdk 7 (headless)
#

if [ $(id -u) != 0 ]; then
    echo "ERROR: $0 must be be run as root, not as `whoami`" 2>&1
    exit 1
fi
export DEBIAN_FRONTEND=noninteractive

if [[ ! -e  /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java ]]; then
    apt-get -y install openjdk-7-jre-headless curl
fi

