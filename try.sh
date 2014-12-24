#!/bin/bash

#
## Using nova cli
## Script to try that the installation has been succesfull
#
#
echo -e "$_BOLD$_BLUE Using some commands... $_RESET"
nova list
nova image-list
nova flavor-list
nova keypair-list
sleep 5

echo -e "$_BOLD$_BLUE Setting image and flavours... $_RESET"
# wget https://launchpad.net/cirros/trunk/0.3.0/+download/cirros-0.3.0-x86_64-disk.img
# did this already, you can check it is in the repo
IMG_ID=$(glance add name="cirrOS-0.3.0-x86_64" is_public=true container_format=bare disk_format=qcow2 distro="cirrOS-0.3.0-x86_64" < vm-images/cirros-0.3.0-x86_64-disk.img)
# Trim it to just get the ID
IMG_ID=$(echo ${IMG_ID##* })

# to connect to it via SSH we will need to upload a public-key pair
# ssh-keygen to create a key pair
nova keypair-add --pub_key keys/id_rsa.pub id_rsa
echo -e "$_BOLD$_BLUE Booting first instance... $_RESET"
echo -e "$_BOLD$_YELLOW Need 1GB Ram at least... $_RESET"
nova boot --poll --flavor 1 --image $IMG_ID --key_name id_rsa my_1st_instance
# we can output it!
nova show my_1st_instance

# We can activate ssh access, create a floating IP 
# and attach it to our instance
echo -e "$_BOLD$_BLUE enabling SSH access... $_RESET"
nova secgroup-add-rule default tcp 22 22 0.0.0.0/0
nova floating-ip-create