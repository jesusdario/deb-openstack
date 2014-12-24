#!/bin/bash

export OS_USERNAME=admin
export OS_PASSWORD=stack
export OS_TENANT_NAME=admin
export OS_AUTH_URL=http://localhost:5000/v2.0/
export OS_VERSION=1.1

export ADMIN_ROLE=$(keystone role-list|awk '/ admin / { print $2 }')
export KEYSTONEADMIN_ROLE=$(keystone role-list|awk '/ KeystoneAdmin / { print $2 }')
export KEYSTONESERVICEADMIN_ROLE=$(keystone role-list|awk '/ KeystoneServiceAdmin / { print $2 }')
