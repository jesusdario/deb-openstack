#!/bin/bash

. colors.sh

set -e;

echo -e "$_RED Uninstalling all OpenStack modules and services... $_RESET";
apt-get remove -y mysql-server rabbitmq-server memcached;
apt-get remove -y nova-api nova-scheduler keystone;
apt-get remove -y glance;
apt-get remove -y openstack-dashboard openstack-dashboard-apache;
apt-get remove -y nova-console novnc nova-compute nova-network nova-cert;
apt-get autoremove -y;