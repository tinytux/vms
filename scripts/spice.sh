#!/bin/bash
#
# Add the qemu/kvm SPICE guest agent 
#

if [ $(id -u) != 0 ]; then
    echo "ERROR: $0 must be be run as root, not as `whoami`" 2>&1
    exit 1
fi

DEBIAN_FRONTEND=noninteractive

apt-get -y install spice-vdagent xserver-xorg-video-qxl xserver-xorg xinit xfonts-100dpi xfonts-scalable xfonts-75dpi xinput

