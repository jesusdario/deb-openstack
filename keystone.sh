#!/bin/bash

. colors.sh

echo -e "$_BOLD$_BLUE Setting keystone variables $_RESET"
echo -e "$_BOLD$_YELLOW SERVICE_ENDPOINT=http://127.0.0.1:35357/v2.0/ $_RESET"
echo -e "$_BOLD$_YELLOW SERVICE_TOKEN=ADMIN $_RESET"
export SERVICE_ENDPOINT=http://127.0.0.1:35357/v2.0/
export SERVICE_TOKEN=ADMIN

# Many keystone arguments require numerical IDs that are unpractical to remember
# this function retrives the numerical ID and stores it in a variable
function get_id () {
	echo `$@ | awk '/ id / { print $4 }'`
}

# Create a tenant and store his id
echo -e "$_BOLD$_YELLOW <admin_project> = admin $_RESET"
ADMIN_TENANT=$(get_id keystone tenant-create --name admin)

echo -e "$_BOLD$_YELLOW <admin_user> = admin $_RESET"
echo -e "$_BOLD$_YELLOW <secret> = stack $_RESET"
echo -e "$_BOLD$_YELLOW <admin@example.com> = admin@stack.com $_RESET"
ADMIN_USER=$(get_id keystone user-create --name admin --pass stack --email admin@stack.com)

echo -e "$_BBLUE Creating roles for admins $_RESET"
keystone role-create --name admin
keystone role-create --name KeystoneAdmin
keystone role-create --name KeystoneServiceAdmin

echo -e "$_BBLUE Grant admin rights on tenant <admin_project> $_RESET"
#
ADMIN_ROLE=$(keystone role-list|awk '/ admin / { print $2 }')
keystone user-role-add --user $ADMIN_USER --role $ADMIN_ROLE --tenant_id $ADMIN_TENANT
KEYSTONEADMIN_ROLE=$(keystone role-list|awk '/ KeystoneAdmin / { print $2 }')
keystone user-role-add --user $ADMIN_USER --role $KEYSTONEADMIN_ROLE --tenant_id $ADMIN_TENANT
KEYSTONESERVICEADMIN_ROLE=$(keystone role-list|awk '/ KeystoneServiceAdmin / { print $2 }')
keystone user-role-add --user $ADMIN_USER --role $KEYSTONESERVICEADMIN_ROLE --tenant_id $ADMIN_TENANT