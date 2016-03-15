#!/bin/bash
#
# First script called after initial installation of the OS.
#

if [ $(id -u) != 0 ]; then
    echo "ERROR: $0 must be be run as root, not as `whoami`" 2>&1
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

# disable ipv6 - apt-get sometimes tries to connect to IPv6 addresses...
echo "Disabling IPv6 after next reboot..."
sed -e '/^GRUB_CMDLINE_LINUX_DEFAULT=/s/"$/ ipv6.disable=1"/g' -i /etc/default/grub
update-grub

echo "Updating the system, this takes some time..."
apt-get clean
apt-get -y update >/dev/null
apt-get -y upgrade >/dev/null
apt-get -y dist-upgrade >/dev/null
apt-get -y install perl-modules

