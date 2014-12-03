#!/bin/bash

_RESET="\e[0m"
_BOLD="\e[1m"
_RED="\e[31m"
_GREEN="\e[32m"
_YELLOW="\e[33m"
_BLUE="\e[34m"
_BRED=$_BOLD$_RED
_BBLUE=$_BOLD$_BLUE

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo -e "$_BOLD$_RED You should be root for this!$_RESET"
   exit 1
fi

echo -e "$_BOLD$_BLUE Copying config files... $_RESET"


# Adding testing software for wheezy
# mv sources.list /etc/apt
# Maybe not necessary
#echo -e "$_BOLD$_BLUE Updating software... $_RESET"
#apt-get update -y --force-yes || echo -e "$_BRED update failed" && exit
#apt-get upgrade -y --force-yes || echo -e "$_BRED upgrade failed" && exit

# Note: I chose here to continue without a valid swap area

echo -e "$_BOLD$_BLUE Installing qemu and libvirt-bin... $_RESET"
apt-get install qemu -y --force-yes
apt-get install libvirt-bin -y --force-yes


echo -e "$_BOLD$_BLUE Accept first to install manually mariaDB $_RESET"
sudo apt-get install python-software-properties
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
sudo add-apt-repository 'deb http://tedeco.fi.upm.es/mirror/mariadb/repo/10.1/debian wheezy main'

sudo apt-get update
sudo apt-get install mariadb-server -y --force-yes

# Seems that this pkg is also needed!
echo -e "$_BOLD$_BLUE Installing python-mysqldb dependency $_RESET"
apt-get install python-mysqldb -y --force-yes

# Password for testing I use: root | root