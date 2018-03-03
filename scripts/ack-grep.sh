#!/bin/bash
#
# Add the ack-grep 
#

if [ $(id -u) != 0 ]; then
    echo "ERROR: $0 must be be run as root, not as `whoami`" 2>&1
    exit 1
fi

if [[ ! -e /usr/bin/ack ]]; then
    echo "Installing ack-grep..."
    curl https://beyondgrep.com/ack-2.22-single-file > /usr/bin/ack && chmod 0755 /usr/bin/ack  && ln -s /usr/bin/ack /usr/bin/ack-grep
fi

