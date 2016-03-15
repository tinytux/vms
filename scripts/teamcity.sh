#!/bin/bash
#
# Install TeamCity
#

VERSION="9.1.3"

if [ $(id -u) != 0 ]; then
    echo "ERROR: $0 must be be run as root, not as `whoami`" 2>&1
    exit 1
fi

DEBIAN_FRONTEND=noninteractive

TEAMCITY_USER="build"
INSTALL_DIR="/opt"
TEAMCITY_DIR="${INSTALL_DIR}/TeamCity"
TEAMCITY_BUILDSERVER_BACKUP="/vagrant/files/teamcity/teamcity_buildserver.tar.bz2"
TEAMCITY_CONFIG_BACKUP="/vagrant/files/teamcity/server_config.zip"

cd /vagrant

TAR_FILE="TeamCity-${VERSION}.tar.gz"

if [[ ! -f ${TAR_FILE} ]]; then
    URL="http://download.jetbrains.com/teamcity/${TAR_FILE}"
    echo "wget -q ${URL}"
    echp "This takes some time..."
    wget -q ${URL}
fi

MY_IP=`ifconfig eth1 | awk '/inet addr/{print substr($2,6)}'`
if [[ -e ${TEAMCITY_DIR} ]]; then
    echo "TeamCity already installed."
else
    echo "Installing TeamCity..."

cat >/etc/init.d/teamcity <<EOF
#!/bin/sh
export TEAMCITY_DATA_PATH="${TEAMCITY_DIR}/.BuildServer"

case "\${1}" in
start)
    start-stop-daemon --start  -c ${TEAMCITY_USER} --exec ${TEAMCITY_DIR}/bin/runAll.sh start
;;
stop)
    start-stop-daemon --start -c ${TEAMCITY_USER}  --exec  ${TEAMCITY_DIR}/bin/runAll.sh stop
;;
*)
    echo "usage: \${0} [start|stop]"
esac

exit 0
EOF
    
    apt-get -y install libtcnative-1 unzip

    tar xvf /vagrant/${TAR_FILE} -C ${INSTALL_DIR}
    tar xvf ${TEAMCITY_BUILDSERVER_BACKUP} -C ${TEAMCITY_DIR}

    # restore backup
    if [[ -e ${TEAMCITY_CONFIG_BACKUP} ]]; then
        # create a backup: JRE_HOME=/usr /opt/TeamCity/bin/maintainDB.sh -A /opt/TeamCity/ backup -F /vagrant/files/teamcity/server_config.zip
        
        mkdir -p ${TEAMCITY_DIR}/.BuildServer
        unzip /vagrant/files/teamcity/server_config.zip -d ${TEAMCITY_DIR}/.BuildServer
#        unzip /vagrant/files/teamcity/server_config.zip "lib/*" -d ${TEAMCITY_DIR}/.BuildServer
#        unzip /vagrant/files/teamcity/server_config.zip "plugins/*" -d ${TEAMCITY_DIR}/.BuildServer
#        unzip /vagrant/files/teamcity/server_config.zip "system/*" -d ${TEAMCITY_DIR}/.BuildServer
        JRE_HOME=/usr ${TEAMCITY_DIR}/bin/maintainDB.sh restore -F ${TEAMCITY_CONFIG_BACKUP} -A ${TEAMCITY_DIR} -T ${TEAMCITY_DIR}/.BuildServer/config/database.hsqldb.properties.dist
        
        # update the IP address
        sed -r "s#http://[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}:8111#http://${MY_IP}:8111#g" -i ${TEAMCITY_DIR}/config/main-config.xml
    fi
    
    mkdir -p /data

    useradd ${TEAMCITY_USER}
    chown -R ${TEAMCITY_USER}:${TEAMCITY_USER} /data
    chown -R ${TEAMCITY_USER}:${TEAMCITY_USER} ${TEAMCITY_DIR}

    chmod +x /etc/init.d/teamcity
    sudo update-rc.d teamcity defaults
    
    service teamcity start
fi

echo "TeamCity v${VERSION}: http://${MY_IP}:8111"
echo " default login: admin/admin and user/user"

