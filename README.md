My Virtual Machines 
===================

Automated provisioning powered by packer.io and some shell scripts.

## Create a Vagrant base box with Packer

Packer creates a new virtual machine, installs the base operating system from an .iso file
and packs the VM into a Vagrant box. Vagrant can use this box as template to create customized
virtual machines.

### Debian Jessie 8.0 RC3

- Install Debian Jessie from debian-jessie-DI-rc3-amd64-netinst.iso using a preseed file
- en_US.UTF-8 locale with Swiss German keyboard

Usage on Debian Wheezy 7.8:

    $ git clone https://github.com/tinytux/vms.git
    $ cd vms
    $ ./build.sh qemu/debian-jessie.json

### Debian Wheezy 7.8

- Install Debian Wheezy from debian-7.8.0-amd64-netinst.iso using a preseed file
- en_US.UTF-8 locale with Swiss German keyboard

Usage on Debian Wheezy 7.8:

    $ git clone https://github.com/tinytux/vms.git
    $ cd vms
    $ ./build.sh qemu/debian-wheezy.json



## Create virtual machines with Vagrant


### Debian Jessie 8.0 RC3 with Elasic Search, Logstash and Kibana

 - Based on the debian-jessie.json (see above)

Usage on Debian Wheezy 7.8:
    
    $ vagrant plugin install vagrant-bindfs
    $ cd debian-jessie-elk 
    $ vagrant up


### Debian Jessie 8.0 RC3

 - Based on the debian-jessie.json (see above)

Usage on Debian Wheezy 7.8:

    $ vagrant plugin install vagrant-bindfs
    $ cd debian-jessie 
    $ vagrant up



