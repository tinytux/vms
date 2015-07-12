My Virtual Machines 
===================

Automated provisioning powered by packer.io and some shell scripts.
Tested on a Debian Wheezy 8.1 host.

## Create a Vagrant base box with Packer

Packer creates a new virtual machine, installs the base operating system from an .iso file
and packs the VM into a Vagrant box. Vagrant can use this box as template to create customized
virtual machines.

### Debian Jessie 8.1

- Install Debian Jessie from debian-8.1.0-amd64-netinst.iso using a preseed file
- en_US.UTF-8 locale with Swiss German keyboard
- works behind a proxy (use http_proxy, https_proxy, ftp_proxy and no_proxy)

Usage:

    $ git clone https://github.com/tinytux/vms.git
    $ cd vms
    $ ./build.sh qemu/debian-jessie.json

### Debian Wheezy 7.8

- Install Debian Wheezy from debian-7.8.0-amd64-netinst.iso using a preseed file
- en_US.UTF-8 locale with Swiss German keyboard
- works behind a proxy (use http_proxy, https_proxy, ftp_proxy and no_proxy)

Usage:

    $ git clone https://github.com/tinytux/vms.git
    $ cd vms
    $ ./build.sh qemu/debian-wheezy.json



## Create virtual machines with Vagrant

Install qemu-kvm, vagrant and the libvirt provider (qemu + kvm):
    
    $ sudo apt-get install vagrant virt-manager virt-viewer libvirt-dev qemu-kvm qemu-system
    $ vagrant plugin install vagrant-libvirt
    $ vagrant plugin install vagrant-bindfs

### Debian Jessie 8.1 multi-machine

 - Based on the debian-jessie.json (see above)
 - Node configuration defined in [nodes.yaml](debian-jessie-mm/nodes.yaml)

    $ cd debian-jessie-mm
    $ vagrant up


### Debian Jessie 8.1 with Elasic Search, Logstash and Kibana

 - Based on the debian-jessie.json (see above)

Usage:

    $ cd debian-jessie-elk 
    $ vagrant up


### Debian Jessie 8.1

 - Based on the debian-jessie.json (see above)

Usage:

    $ cd debian-jessie 
    $ vagrant up

