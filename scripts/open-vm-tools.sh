#!/bin/bash
#
# Add open-vm-tools 
#

if [ $(id -u) != 0 ]; then
    echo "ERROR: $0 must be be run as root, not as `whoami`" 2>&1
    exit 1
fi

DEBIAN_FRONTEND=noninteractive

if [[ ! -e /usr/bin/vmtoolsd ]]; then
    if [[ "$(dmidecode -s system-product-name)" == "VMware Virtual Platform" ]]; then
        echo "VMware detected: installing open-vm-tools"
        apt-get -y install open-vm-tools
    fi
fi

if [[ ! -e /etc/vmware-tools/xautostart.conf ]]; then
    if [[ -e /usr/bin/X11 ]]; then
        if [[ "$(dmidecode -s system-product-name)" == "VMware Virtual Platform" ]]; then
            echo "VMware with X11 detected: installing open-vm-tools-desktop"
            apt-get -y install open-vm-tools-desktop
        fi
    fi
fi

