#!/bin/bash
#
# Install Logstash
#

if [ $(id -u) != 0 ]; then
    echo "ERROR: $0 must be be run as root, not as `whoami`" 2>&1
    exit 1
fi

cd /vagrant

DEB_FILE="logstash_1.5.0.rc2-1_all.deb"

if [[ ! -f ${DEB_FILE} ]]; then
    URL="http://download.elastic.co/logstash/logstash/packages/debian/${DEB_FILE}"
    echo "wget -q ${URL}"
    wget -q ${URL}
fi


if [[ ! -e /opt/logstash ]]; then
    apt-get -y install systemd
    dpkg -i ${DEB_FILE}
fi


