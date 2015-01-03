#!/bin/bash

. colors.sh

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo -e "$_BOLD$_RED You should be root for this!$_RESET";
   exit 1;
fi

set -e; # exit if returned value differ 0

echo -e "$_BOLD$_BLUE Installing dependencies... $_RESET";
apt-get install -y mysql-server
# default password for mysql used: stack
apt-get install -y rabbitmq-server memcached

# modificar bind-address
sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/my.cnf
service mysql restart

echo -e "$_BOLD$_BLUE Installing openstack packages... $_RESET"
echo -e "$_BOLD$_YELLOW Choose the proposed defaults! $_RESET"
apt-get install -y nova-api # No -> Nova api will use sqlite
apt-get install -y nova-scheduler
apt-get install -y keystone
# I left admin_token = <ADMIN> = ADMIN
# so no changes are needed in keystone
# restart keystone is not mandatory


#
## GLOBAL VARIABLES
#
echo -e "$_BOLD [[ Configuring global vars ]] $_RESET"
echo -e "OS_USERNAME = <admin_user> = admin"
echo -e "OS_PASSWORD = <secret> = stack"
echo -e "OS_TENANT_NAME = <admin_project> = admin"
echo -e "OS_AUTH_URL = http://<mgmt.host>:5000/v2.0/ -> localhost"

export OS_USERNAME=admin
export OS_PASSWORD=stack
export OS_TENANT_NAME=admin
export OS_AUTH_URL=http://localhost:5000/v2.0/
export OS_VERSION=1.1

#
## KEYSTONE CONFIGURATION
#
echo -e "$_BOLD [[ Configuring Keystone ]] $_RESET"
echo -e "$_BOLD$_BLUE Setting keystone variables $_RESET"
echo -e "SERVICE_ENDPOINT=http://127.0.0.1:35357/v2.0/"
echo -e "SERVICE_TOKEN=ADMIN"
export SERVICE_ENDPOINT=http://127.0.0.1:35357/v2.0/
export SERVICE_TOKEN=ADMIN

# Many keystone arguments require numerical IDs that are unpractical to remember
# this function retrives the numerical ID and stores it in a variable
function get_id () {
	echo `$@ | awk '/ id / { print $4 }'`
}

# Create a tenant and store his id
echo -e "$_BOLD$_YELLOW <admin_project> = admin $_RESET"
export ADMIN_TENANT=$(get_id keystone tenant-create --name admin)

echo -e "<admin_user> = admin"
echo -e "<secret> = stack"
echo -e "<admin@example.com> = admin@stack.com"
export ADMIN_USER=$(get_id keystone user-create --name admin --pass stack --email admin@stack.com)

echo -e "$_BBLUE Creating roles for admins $_RESET"
keystone role-create --name admin
keystone role-create --name KeystoneAdmin
keystone role-create --name KeystoneServiceAdmin

echo -e "$_BBLUE Grant admin rights on tenant <admin_project> $_RESET"
#
export ADMIN_ROLE=$(keystone role-list|awk '/ admin / { print $2 }')
keystone user-role-add --user $ADMIN_USER --role $ADMIN_ROLE --tenant_id $ADMIN_TENANT
export KEYSTONEADMIN_ROLE=$(keystone role-list|awk '/ KeystoneAdmin / { print $2 }')
keystone user-role-add --user $ADMIN_USER --role $KEYSTONEADMIN_ROLE --tenant_id $ADMIN_TENANT
export KEYSTONESERVICEADMIN_ROLE=$(keystone role-list|awk '/ KeystoneServiceAdmin / { print $2 }')
keystone user-role-add --user $ADMIN_USER --role $KEYSTONESERVICEADMIN_ROLE --tenant_id $ADMIN_TENANT
# No changes in default_catalog.templates, I decided to leave
# localhost as <mgmt.host>
# probably need to change that, don't know yet
# no need to restart, then


#
## GLANCE ##
#
echo -e "$_BOLD$_BLUE Installing glance ... $_RESET"
echo -e "$_BOLD$_YELLOW Choose keystone and set ADMIN as token! $_RESET"
# choose keystone
# let localhost
# token de administracion <ADMIN> = ADMIN
apt-get install -y glance
# Coment out admin_tenant_name, admin_user & admin_password
echo -e "$_BOLD$_BLUE Copying glance-config files ... $_RESET"
cp conf-files/glance-api-paste.ini /etc/glance/glance-api-paste.ini
cp conf-files/glance-registry-paste.ini /etc/glance/glance-registry-paste.ini

echo -e "$_BOLD$_BLUE Restarting glance ... $_RESET"
service glance-api restart
service glance-registry restart


#
## NOVA
#
echo -e "$_BOLD$_BLUE Copying nova-config files ... $_RESET"
cp conf-files/api-paste.ini /etc/nova/api-paste.ini
# I did NOT change <mgmt.host>
echo -e "$_BRED Since I am on single-node I did NOT change nova.conf $_RESET";
echo -e "$_BOLD$_BLUE Syncing nova-manage ... $_RESET"
nova-manage db sync
echo -e "$_BOLD$_BLUE Restarting nova ... $_RESET"
service nova-api restart
service nova-scheduler restart


echo -e "$_BOLD$_BLUE Bootrapping nova ... $_RESET"
echo -e "$_BOLD$_YELLOW I made up some values myself $_RESET";
nova-manage network create private --fixed_range_v4=10.11.12.0/24 --network_size=4 --num_networks=8 --bridge_interface=lo
nova-manage floating create --ip_range=192.168.1.224/28
echo -e "$_BOLD$_GREEN We can see the state of nova now! $_RESET"
nova-manage service list


#
## DASHBOARD
#
echo -e "$_BOLD$_BLUE Installing dashboard ... $_RESET"
apt-get install -y openstack-dashboard openstack-dashboard-apache
echo -e "$_BOLD$_BLUE Copying dashboard-config files ... $_RESET"
cp conf-files/local_settings.py /etc/openstack-dashboard/local_settings.py
cp conf-files/ports.conf /etc/apache2/ports.conf
echo -e "$_BOLD$_BLUE Giving permissions to www-data on /var/www/ ... $_RESET"
chown www-data /var/www/
service apache2 restart

#
## Installing the VNC console
#
echo -e "$_BOLD$_BLUE Installing Compute console and module... $_RESET"
echo -e "$_BRED Now I changed nova.conf $_RESET";
cp conf-files/nova.conf /etc/nova/nova.conf
apt-get install -y nova-console novnc
apt-get install -y nova-compute nova-api nova-network nova-cert
echo -e "$_BOLD$_GREEN Check services are up! $_RESET"
nova-manage service list