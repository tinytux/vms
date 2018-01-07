#!/bin/python
#
# CloudSigma / libcloud node control utility
#

import os
import sys
from configobj import ConfigObj
import argparse
from time import sleep

from libcloud.compute.types import Provider
from libcloud.compute.providers import get_driver

homefolder = os.path.expanduser('~')
configfile = os.path.join(homefolder, '.cloudsigma.conf')
sshpubkeyfile = os.path.join(homefolder, '.ssh/id_rsa.pub')
templatename = 'Ubuntu 16.04 LTS'
# server size see https://github.com/apache/libcloud/blob/trunk/libcloud/common/cloudsigma.py#L91
serversize = 'micro-regular'

# Command line parsing
parser = argparse.ArgumentParser(description="CloudSigma remote node utility")
parser.add_argument('-ls', '--list', action='store_true', help='List all servers.')
parser.add_argument('--create', help='Create and start a server.')
parser.add_argument('--start',  help='Start a server.')
parser.add_argument('--stop',   help='Stop a server.')
parser.add_argument('--destroy', help='Destroy (permanently delete) a server and all associated disks. Use with care!')
args, unknownargs = parser.parse_known_args()
if not args or unknownargs or len(sys.argv) == 1:
    parser.print_help()
    sys.exit(1)

# Load config file and connect to the cloud...
config = ConfigObj(configfile)
print('Connecting ' + config['api_endpoint'] + '...')
cls = get_driver(Provider.CLOUDSIGMA)
driver = cls(config['username'], config['password'], region='zrh', api_version='2.0')

balance = driver.ex_get_balance()
values = {'balance': float(balance['balance']), 'currency': balance['currency']}
print('Account balance: %(balance).4f %(currency)s' % values)

nodes = driver.list_nodes()
if not args.create and not nodes:
    print('No nodes found.')
    sys.exit(1)

if args.list:
    print('Nodes:')
    for node in nodes:
        ip = ''
        if node.public_ips:
            ip = ' ' + str(node.public_ips[0]) + '  '
        print('  ' + node.name + ' (' + node.state + ')' + ip +  str(node.extra['mem'] / (1024*1024)) + 'MB RAM  ' + str(node.extra['cpu'])  + 'HZ cpu')
       
    print('Drives:')
    drives = driver.ex_list_user_drives()
    if not drives:
        print('  no drives found')
    else:
        for drive in drives:
            print('  ' + drive.name + ' ' + str(drive.size / (1024*1024*1024)) + 'GB')
   
    print('Server sizes:')
    sizes = driver.list_sizes()
    if not sizes:
        print('  no size information found')
    else:
        for size in sizes:
            print('  ' + size.name + ' (' + size.id + ')' + '< with ' + str(size.disk) + 'GB disk ' + str(size.ram) + 'MB RAM  ' + str(size.cpu) + 'HZ cpu @ ' +  str(size.price * 24) + 'CHF/day...')
            #print size
 
    #print('Subscriptions:')
    #subscriptions = driver.ex_list_subscriptions();
    #if not subscriptions:
    #    print('  no subscriptions found')
    #else:
    #    #TODO: fix   File "~/.local/lib/python2.7/site-packages/libcloud/compute/drivers/cloudsigma.py", line 1969, if end_time is None
    #    for subscription in subscriptions:
    #        print subscription
    
elif args.start:
    nodename = args.start
    for node in nodes:
        if node.name == nodename and node.state == 'stopped':
            print('Starting node ' + nodename + '...')
            driver.ex_start_node(node)
            sys.exit(0)
    print('Can not start node ' + nodename)
elif args.stop:
    nodename = args.stop
    for node in nodes:
        if node.name == nodename and node.state == 'running':
            print('Stopping node ' + nodename + '...')
            driver.ex_stop_node(node)
            sys.exit(0)
    print('Can not stop node ' + nodename)
elif args.destroy:
    nodename = args.destroy
    for node in nodes:
        if node.name == nodename:
            print('Permanently deleting node ' + nodename + ' with all the associated drives...')
            if node.state == 'running':
                print('Stopping node ' + nodename + '...')
                driver.ex_stop_node(node)
            print('Destroying node ' + nodename + '...')
            print('Press CTRL+C to abort NOW!')
            sleep(10)
            driver.destroy_node(node)
            sys.exit(0)
    print('Can not detroy (delete) node and disk ' + nodename)
elif args.create:
    nodename = args.create
    if not os.path.isfile(configfile):
        print('Could not find config file: ' + configfile)
        sys.exit(1)
    print('Creating and starting node ' + nodename + ':')
    with open(sshpubkeyfile, 'r') as keyfile:
        sshpubkey=keyfile.read().replace('\n', '')
    print(' - trying to find the ' + templatename + ' template image...')
    sizes = driver.list_sizes()
    images = driver.list_images()
    size = [size for size in sizes if size.id == serversize][0]

    #size.ram = 16384
    #size.cpu = 10000
    #size.disk = 50

    # List all available Templates
    image = [i for i in images if i.name == templatename][0]

    metadata = {'ssh_public_key': sshpubkey,
                'region': 'zrh'}

    #print size
    print(' - creating node >' + nodename + '< with ' + str(size.disk) + 'GB disk ' + str(size.ram) + 'MB RAM  ' + str(size.cpu) + 'HZ cpu @ ' +  str(size.price * 24) + 'CHF/day...')
    node = driver.create_node(name=nodename, size=size, image=image, ex_metadata=metadata)
    print(' - node created: ' + node.name + ' (' + node.state + ')  ' +  str(node.extra['mem'] / (1024*1024)) + 'MB RAM  ' + str(node.extra['cpu'])  + 'HZ cpu')
    print('The new node ' + nodename + ' will now boot and start to consume resources!')


