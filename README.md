My Virtual Machines 
===================

Automated provisioning powered by packer.io and some shell scripts.

## Debian Wheezy 7.8

- Install Debian Wheezy from debian-7.8.0-amd64-netinst.iso using a preseed file
- en_US.UTF-8 locale with Swiss German keyboard

Usage on Debian Wheezy 7.8:

    $ git clone https://github.com/tinytux/vms.git
    $ cd vms
    $ ./build.sh debian-wheezy-qemu.json


