#!/bin/bash

. colors.sh

echo -e "$_BOLD$_YELLOW OS_USERNAME = <admin_user> = admin $_RESET"
echo -e "$_BOLD$_YELLOW OS_PASSWORD = <secret> = stack $_RESET"
echo -e "$_BOLD$_YELLOW OS_TENANT_NAME = <admin_project> = admin $_RESET"
echo -e "$_BOLD$_YELLOW OS_AUTH_URL = http://<mgmt.host>:5000/v2.0/ -> localhost $_RESET"

export OS_USERNAME=admin
export OS_PASSWORD=stack
export OS_TENANT_NAME=admin
export OS_AUTH_URL=http://localhost:5000/v2.0/
export OS_VERSION=1.1