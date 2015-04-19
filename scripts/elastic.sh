#!/bin/bash
#
# Install Elastic Search
#

if [ $(id -u) != 0 ]; then
    echo "ERROR: $0 must be be run as root, not as `whoami`" 2>&1
    exit 1
fi

APT_URL="http://packages.elasticsearch.org/elasticsearch/1.5/debian"
if [[ ! -n "`grep  ${APT_URL} /etc/apt/sources.list`" ]]; then
    wget --no-check-certificate -qO - https://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -
    echo "deb ${APT_URL} stable main" | sudo tee -a /etc/apt/sources.list
    apt-get -y update
fi

apt-get -y install openjdk-7-jre-headless curl
apt-get -y install elasticsearch

# elasticsearch-1.5.1.deb does not create all directories
if [[ ! -e /usr/share/elasticsearch/config ]]; then
    mkdir -p /usr/share/elasticsearch/config
    ln -s /etc/elasticsearch/elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml
    ln -s /etc/elasticsearch/logging.yml /usr/share/elasticsearch/config/logging.yml
fi

if [[ ! -e /usr/share/elasticsearch/data ]]; then
    mkdir -p /usr/share/elasticsearch/data
    chown elasticsearch:elasticsearch /usr/share/elasticsearch/data
fi

if [[ ! -e /usr/share/elasticsearch/logs ]]; then
    ln -s /var/log/elasticsearch /usr/share/elasticsearch/logs
fi

systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service




