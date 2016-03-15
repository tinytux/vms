#!/bin/bash
#
# Fill the disk with zero bytes to help Vagrant compact the virtual disk
#

if [ $(id -u) != 0 ]; then
    echo "ERROR: $0 must be be run as root, not as `whoami`" 2>&1
    exit 1
fi

DEBIAN_FRONTEND=noninteractive

dd if=/dev/zero of=/EMPTYFILE bs=1M
rm -f /EMPTYFILE

