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

    # Allow access to the syslog file
    sed -e "s#^.*LS_CONF_DIR.*#LS_CONF_DIR=/etc/logstash/conf.d#" -i /etc/default/logstash    
    sed -e "s#^.*LS_USER.*#LS_USER=logstash#" -i /etc/default/logstash
    echo -e "\nLS_GROUP=adm" >>  /etc/default/logstash

    # Sample configuration for syslog
    cp /vagrant/logstash-syslog.conf /etc/logstash/conf.d/logstash-syslog.conf
    
    service logstash restart
fi


