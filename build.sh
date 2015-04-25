#!/bin/bash
#
# Build a new VM from scratch, download packer.io binaries if required.
#

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

OLDDIR=`pwd`
SCRIPTDIR="$(dirname "${0}")"
cd ${SCRIPTDIR}/qemu

if [[ ! -f packer/packer ]]; then
    echo "Downloading packer.io..."
    if [[ ! -f packer_0.7.5_linux_amd64.zip ]]; then
        wget https://dl.bintray.com/mitchellh/packer/packer_0.7.5_linux_amd64.zip
    fi
    unzip -d packer packer_0.7.5_linux_amd64.zip
fi


./packer/packer build "${FILE}"


cd $OLDDIR


