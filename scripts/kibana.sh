#!/bin/bash
#
# Install Kibana
#

if [ $(id -u) != 0 ]; then
    echo "ERROR: $0 must be be run as root, not as `whoami`" 2>&1
    exit 1
fi

cd /vagrant

KIBANA_VERSION="4.1.2"

TAR_FILE="kibana-${KIBANA_VERSION}-linux-x64.tar.gz"

if [[ ! -f ${TAR_FILE} ]]; then
    URL="https://download.elastic.co/kibana/kibana/${TAR_FILE}"
    echo "wget -q ${URL}"
    wget -q ${URL}
fi

MY_IP=`ifconfig eth0 | awk '/inet addr/{print substr($2,6)}'`
if [[ ! -e /opt/kibana ]]; then
    mkdir -p /opt/kibana
    tar xf ${TAR_FILE} -C /opt/kibana --strip-components=1

    # set the elasticsearch IP address
    sed "s#http://localhost:9200#http://${MY_IP}:9200#g" -i /opt/kibana/config/kibana.yml

    wget --no-check-certificate -qO - https://gist.githubusercontent.com/thisismitch/8b15ac909aed214ad04a/raw/bce61d85643c2dcdfbc2728c55a41dab444dca20/kibana4 >/etc/init.d/kibana

    chmod +x /etc/init.d/kibana
    update-rc.d kibana defaults 96 9
    service kibana start
else
    # update the elasticsearch IP address
    sed -r "s#http://[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}:9200#http://${MY_IP}:9200#g" -i /opt/kibana/config/kibana.yml
fi

echo "Elastic: http://${MY_IP}:9200/_search?pretty"
echo "Kibana ${KIBANA_VERSION}: http://${MY_IP}:5601"

