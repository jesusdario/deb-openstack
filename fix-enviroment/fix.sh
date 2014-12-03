#!/bin/bash

_RESET="\e[0m"
_BOLD="\e[1m"
_RED="\e[31m"
_GREEN="\e[32m"
_YELLOW="\e[33m"
_BLUE="\e[34m"


# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo -e "$_BOLD$_RED You should be root for this!$_RESET"
   exit 1
fi

rm /etc/apt/apt.conf.d/*proxies

# Edit /etc/environmet to delete some lines
cp environment /etc/environment

# Update the repos
apt-get update
apt-get upgrade

# Install git in order to be not clumpsy!
apt-get install git -y --force-yes

echo -e "$_BOLD$_BLUE done! $_RESET"