My Virtual Machines 
===================

Automated provisioning powered by packer.io and some shell scripts.
Tested on a Debian Wheezy 8.0 host.

## Create a Vagrant base box with Packer

Packer creates a new virtual machine, installs the base operating system from an .iso file
and packs the VM into a Vagrant box. Vagrant can use this box as template to create customized
virtual machines.

### Debian Jessie 8.0

- Install Debian Jessie from debian-8.0.0-amd64-netinst.iso using a preseed file
- en_US.UTF-8 locale with Swiss German keyboard

Usage:

    $ git clone https://github.com/tinytux/vms.git
    $ cd vms
    $ ./build.sh qemu/debian-jessie.json

### Debian Wheezy 7.8

- Install Debian Wheezy from debian-7.8.0-amd64-netinst.iso using a preseed file
- en_US.UTF-8 locale with Swiss German keyboard

Usage:

    $ git clone https://github.com/tinytux/vms.git
    $ cd vms
    $ ./build.sh qemu/debian-wheezy.json



## Create virtual machines with Vagrant


### Debian Jessie 8.0 multi-machine

 - Based on the debian-jessie.json (see above)
 - Node configuration defined in [nodes.yaml](debian-jessie-mm/nodes.yaml)

Create multiple nodes with one command:
    
    $ vagrant plugin install vagrant-bindfs
    $ cd debian-jessie-mm
    $ vagrant up


### Debian Jessie 8.0 with Elasic Search, Logstash and Kibana

 - Based on the debian-jessie.json (see above)

Usage:

    $ vagrant plugin install vagrant-bindfs
    $ cd debian-jessie-elk 
    $ vagrant up


### Debian Jessie 8.0

 - Based on the debian-jessie.json (see above)

Usage:

    $ vagrant plugin install vagrant-bindfs
    $ cd debian-jessie 
    $ vagrant up

