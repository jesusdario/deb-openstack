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

echo -e "Accept first to install manually mariaDB"
sudo apt-get install python-software-properties
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
sudo add-apt-repository 'deb http://tedeco.fi.upm.es/mirror/mariadb/repo/10.1/debian wheezy main'

sudo apt-get update
sudo apt-get install mariadb-server -y --force-yes

# Password for testing I use: root | root

# We have to start it...
service mysql start

echo -e "$_BOLD$_YELLOW Creating user for stack.sh... $_RESET"

adduser stack

# I use stack as password for testing

apt-get install sudo -y || yum install -y sudo
echo "stack ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Now we move on...
mv local.conf.example devstack/local.conf
chown stack:stack
su stack

