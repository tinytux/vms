My Virtual Machines 
===================

Automated provisioning powered by packer.io and some shell scripts.
Tested on a Debian Stretch (testing) host.

## Create a Vagrant base box with Packer

Packer creates a new virtual machine, installs the base operating system from an .iso file
and packs the VM into a Vagrant box. Vagrant can use this box as template to create customized
virtual machines. Features:

- en_US.UTF-8 locale with Swiss German keyboard
- works behind a proxy (use http_proxy, https_proxy, ftp_proxy and no_proxy)

Usage:

    $ git clone https://github.com/tinytux/vms.git
    $ cd vms
    $ ./build.sh qemu/debian-stretch.json
    $ ./build.sh qemu/debian-jessie.json
    $ ./build.sh vmware/debian-stretch.json
    $ ./build.sh vmware/debian-jessie.json


## Create virtual machines with Vagrant

Install [qemu-kvm](https://wiki.debian.org/KVM), [vagrant](https://www.vagrantup.com/downloads.html) and the libvirt provider (qemu + kvm):
    
    $ wget https://releases.hashicorp.com/vagrant/1.9.1/vagrant_1.9.1_x86_64.deb
    $ sudo dpkg --install vagrant_1.8.6_x86_64.deb
    $ vagrant plugin install vagrant-libvirt
    $ vagrant plugin install vagrant-bindfs


Install [VMware Workstation for Linux](http://www.vmware.com/products/workstation-for-linux.html) (license required), [vagrant-vmware-workstation](https://www.vagrantup.com/vmware/) plugin (license required) and [vagrant](https://www.vagrantup.com/downloads.html):
    
    $ wget https://releases.hashicorp.com/vagrant/1.9.1/vagrant_1.9.1_x86_64.deb
    $ sudo dpkg --install vagrant_1.9.1_x86_64.deb
    $ vagrant plugin install vagrant-vmware-workstation
    $ vagrant plugin install vagrant-bindfs

### Debian Stretch

 - Based on the debian-stretch.json (see above)

Usage:

    $ cd debian-stretch-gnome
    $ vagrant up


### Debian Jessie multi-machine

 - Based on the debian-jessie.json (see above)
 - Node configuration defined in [nodes.yaml](debian-jessie-mm/nodes.yaml)

    $ cd debian-jessie-mm
    $ vagrant up


### Debian Jessie with Elastic, Logstash and Kibana

 - Based on the debian-jessie.json (see above)

Usage:

    $ cd debian-jessie-elk 
    $ vagrant up


### Debian Jessie

 - Based on the debian-jessie.json (see above)

Usage:

    $ cd debian-jessie 
    $ vagrant up

