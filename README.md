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

Install [qemu-kvm](https://wiki.debian.org/KVM), [vagrant](https://www.vagrantup.com/downloads.html) and the libvirt provider (qemu + kvm).
Debian Stretch may need this [workaround](https://gist.github.com/robled/070e1922816bbe983623#gistcomment-1978432).
    
    $ sudo apt-get install libvirt-daemon-system
    $ wget https://releases.hashicorp.com/vagrant/2.0.2/vagrant_2.0.2_x86_64.deb
    $ sudo dpkg --install vagrant_2.0.2_x86_64.deb
    $ vagrant plugin install vagrant-libvirt
    $ vagrant plugin install vagrant-bindfs


Install [VMware Workstation for Linux](http://www.vmware.com/products/workstation-for-linux.html) (license required), [vagrant-vmware-workstation](https://www.vagrantup.com/vmware/) plugin (license required) and [vagrant](https://www.vagrantup.com/downloads.html):
    
    $ wget https://releases.hashicorp.com/vagrant/2.0.2/vagrant_2.0.2_x86_64.deb
    $ sudo dpkg --install vagrant_2.0.2_x86_64.deb
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


### CloudSigma

 - Control CloudSigma nodes
 
Configuration:

    $ cat ~/.cloudsigma.conf 
    $ # https://github.com/cloudsigma/pycloudsigma
    $ api_endpoint = https://zrh.cloudsigma.com/api/2.0/
    $ ws_endpoint = wss://direct.zrh.cloudsigma.com/websocket
    $ username = myusername 
    $ password = mypassword


Usage:

    $ cd cloudsigma
    $ ./cloud.py --help
    usage: cloud.py [-h] [-ls] [--create CREATE] [--start START] [--stop STOP]
                     [--destroy DESTROY]
     
    CloudSigma remote node utility
     
    optional arguments:
      -h, --help         show this help message and exit
      -ls, --list        List all servers.
      --create CREATE    Create and start a server.
      --start START      Start a server.
      --stop STOP        Stop a server.
      --destroy DESTROY  Destroy (permanently delete) a server and all associated
                         disks. Use with care!



