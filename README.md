My Virtual Machines 
===================

Automated provisioning powered by packer.io and some shell scripts.


## Debian Jessie 8.0 RC2

- Install Debian Jessie from debian-jessie-DI-rc2-amd64-netinst.iso using a preseed file
- en_US.UTF-8 locale with Swiss German keyboard

Usage on Debian Wheezy 7.8:

    $ git clone https://github.com/tinytux/vms.git
    $ cd vms
    $ ./build.sh debian-jessie-qemu.json
    $ virsh --connect qemu:///system list --all | grep -q debian-jessie-qemu && virsh --connect qemu:///system undefine debian-jessie-qemu
    $ virt-install \
       --connect qemu:///system \
       --name "debian-jessie-qemu" \
       --cpu host \
       --vcpus 2 \
       --ram 1024 \
       --os-type=linux \
       --os-variant=debianwheezy \
       --disk path=./output/debian-jessie-qemu/debian-jessie-qemu.qcow2,device=disk,bus=virtio,format=qcow2 \
       --vnc  \
       --force \
       --import


## Debian Wheezy 7.8

- Install Debian Wheezy from debian-7.8.0-amd64-netinst.iso using a preseed file
- en_US.UTF-8 locale with Swiss German keyboard

Usage on Debian Wheezy 7.8:

    $ git clone https://github.com/tinytux/vms.git
    $ cd vms
    $ ./build.sh debian-wheezy-qemu.json


