#!/bin/bash
# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo -e "you should be root for this!"
   exit 1
fi

rm /etc/apt/apt.conf.d/*proxies

# Edit /etc/environmet to delete some lines
mv environment /etc/environment

# Install git in order to be not clumpsy!
apt-get install git -y --force-yes
