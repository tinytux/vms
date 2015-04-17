#!/bin/bash
#
# Build a new VM from scratch, download packer.io binaries if required.
#

if [[ $# -ne 1 ]]; then
    echo "usage: $0 [vmtemplate.json]"
    echo -e "\n   example: $0 debian-jessie-qemu.json\n"
    exit 1
fi

FILE=${1}
if [[ ! -f ${FILE} ]]; then
    echo "File not found: >${FILE}<"
    exit 1
fi

if [[ ! -f packer/packer ]]; then
    echo "Downloading packer.io..."
    if [[ ! -f packer_0.7.5_linux_amd64.zip ]]; then
        wget https://dl.bintray.com/mitchellh/packer/packer_0.7.5_linux_amd64.zip
    fi
    unzip -d packer packer_0.7.5_linux_amd64.zip
fi


./packer/packer build "${FILE}"


