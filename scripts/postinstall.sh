#!/bin/bash
#
# First script called after initial installation of the OS.
#

if [ $(id -u) != 0 ]; then
    echo "ERROR: $0 must be be run as root, not as `whoami`" 2>&1
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

# re-enable eth0 interface names
echo "Disabling 'consistent network device naming'..."
sed -e '/^GRUB_CMDLINE_LINUX_DEFAULT=/s/"$/  net.ifnames=0 biosdevname=0"/g' -i /etc/default/grub
update-grub

echo "Updating the system, this takes some time..."
apt-get clean
apt-get -y update >/dev/null
apt-get -y upgrade >/dev/null
apt-get -y dist-upgrade >/dev/null
apt-get -y install perl-modules mc vim bash-completion python-optcomplete nmap

echo "base image build date: $(date)" >/etc/builddate.txt

