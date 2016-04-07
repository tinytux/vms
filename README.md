My Virtual Machines 
===================

Automated provisioning powered by packer.io and some shell scripts.
Tested on a Debian Jessie 8.2 host.

## Create a Vagrant base box with Packer

Packer creates a new virtual machine, installs the base operating system from an .iso file
and packs the VM into a Vagrant box. Vagrant can use this box as template to create customized
virtual machines.

### Debian Jessie 8.2

- Install Debian Jessie from debian-8.2.0-amd64-netinst.iso using a preseed file
- en_US.UTF-8 locale with Swiss German keyboard
- works behind a proxy (use http_proxy, https_proxy, ftp_proxy and no_proxy)

Usage:

    $ git clone https://github.com/tinytux/vms.git
    $ cd vms
    $ ./build.sh qemu/debian-jessie.json




## Create virtual machines with Vagrant

Install qemu-kvm, vagrant and the libvirt provider (qemu + kvm):
    
    $ wget https://releases.hashicorp.com/vagrant/1.8.1/vagrant_1.8.1_x86_64.deb
    $ sudo dpkg --install vagrant_1.8.1_x86_64.deb
    $ vagrant plugin install vagrant-libvirt
    $ vagrant plugin install vagrant-bindfs

### Debian Jessie multi-machine

 - Based on the debian-jessie.json (see above)
 - Node configuration defined in [nodes.yaml](debian-jessie-mm/nodes.yaml)

    $ cd debian-jessie-mm
    $ vagrant up


### Debian Jessie with Elasic Search, Logstash and Kibana

 - Based on the debian-jessie.json (see above)

Usage:

    $ cd debian-jessie-elk 
    $ vagrant up


### Debian Jessie

 - Based on the debian-jessie.json (see above)

Usage:

    $ cd debian-jessie 
    $ vagrant up

