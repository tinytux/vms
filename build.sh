#!/bin/bash
#
# Build a new VM from scratch, download packer.io binaries if required.
#

PACKER_VERSION="0.8.6"

if [[ $# -ne 1 ]]; then
    echo "usage: $0 [vmtemplate.json]"
    echo -e "\n   example: $0 qemu/debian-jessie.json\n"
    exit 1
fi

if [[ ! -f ${1} ]]; then
    echo "File not found: >${1}<"
    exit 1
fi
FILEDIR=$(cd "$(dirname -- "${1}")"; printf %s "$PWD")
FILE=${FILEDIR}/${1##*/}
filename=$(basename $FILE)
vm_name=${filename%.*}

OLDDIR=`pwd`
SCRIPTDIR="$(dirname "${0}")"
cd ${SCRIPTDIR}/qemu

if [[ ! -f packer/packer ]]; then
    echo "Downloading packer.io..."
    if [[ ! -f packer_${PACKER_VERSION}_linux_amd64.zip ]]; then
        wget https://dl.bintray.com/mitchellh/packer/packer_${PACKER_VERSION}_linux_amd64.zip
    fi
    unzip -d packer packer_${PACKER_VERSION}_linux_amd64.zip
fi

mount | grep -q "tmpfs on /tmp type tmpfs"
if [[ $? -eq 0 ]]; then
    export TMPDIR="`pwd`/tmp_vagrant"
    echo "tmpfs detected, using current directory for temp files:"
    mkdir -p $TMPDIR
    echo "TMPDIR = $TMPDIR"
fi


echo "Detecting apt-cacher-ng or http_proxy..."
# Try to find local installation...
grep -qie "Port:"  /etc/apt-cacher-ng/acng.conf 2>/dev/null
if [[ $? -eq 0 ]]; then
    netstat -nl | grep -q "0.0.0.0:3142"
    if [[ $? -eq 0 ]]; then
        LOCAL_IP=`/sbin/ifconfig | grep -E "^eth|^w" -A1 | tr -d '\n' | tr -s ' ' | sed 's/--/\n/g' | sed 's/addr://g' \
| awk '{print $1 " " $7}' | sort | sed "s/  /\t /g" | expand -t 20 | grep -v BROADCAST | sort | head -n1 | cut -d ' ' -f 2`
        if [[ -z ${LOCAL_IP} ]]; then
            echo "local apt-cacher-ng: could not detect local IP"
        else
            export APT_PROXY="http://${LOCAL_IP}:3142"
            echo "local apt-cacher-ng: ${APT_PROXY}"
        fi
    fi
else
    # ... else find the network
    APT_PROXY_IP=`grep -iR '^[ ]*Acquire::http.*Proxy' /etc/apt/* 2>/dev/null | grep -Eo '(http|https)://[^/"]+' | head -n 1`
    export APT_PROXY="http://${APT_PROXY_IP}:3142"
    echo "apt-cacher-ng: ${APT_PROXY}"
fi

if [[ -z  ${APT_PROXY} ]]; then
    if [[ !  -z  ${http_proxy} ]]; then
        # ... else use the http proxy
        export APT_PROXY=${http_proxy}
        echo "http_proxy IP: ${APT_PROXY}"
    fi
fi

# Add proxy to the preseed file
cp -v ./http/${vm_name}-preseed.template ./http/${vm_name}-preseed.cfg
if [[ ! -z  ${APT_PROXY} ]]; then
    echo "Using proxy ${APT_PROXY} in preseed file..."
    sed -e "s#^.*d-i mirror/http/proxy.*#d-i mirror/http/proxy string ${APT_PROXY}#" -i ./http/${vm_name}-preseed.cfg
else
    echo "No proxy detected."
fi

echo "Building VM..."
./packer/packer build "${FILE}"

if [[ $? -eq 0 ]]; then
    echo "Importing box..."
    vagrant box add --force --clean --name "${vm_name}-qemu" output/${vm_name}-qemu.box
fi

mount | grep -q "tmpfs on /tmp type tmpfs"
if [[ $? -eq 0 ]]; then
    echo "Cleaning custom TMPDIR ($TMPDIR)"
    rm -rf $TMPDIR
fi

cd $OLDDIR


