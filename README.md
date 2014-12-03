# Repo for a debian single-machine OpenStack installer
Hacked Devstack!
I'll try to make of it as out-of-the-box as possible

*Links followed:*
* https://wiki.debian.org/OpenStackHowto/Essex
* https://packages.debian.org/wheezy/openstack-dashboard
* https://wiki.debian.org/OpenStack
* http://debian.netside.net/xps13_openstack.html
* More recomendations:*
* http://ispire.me/installing-openstack-on-debian-wheezy-single-node/
* http://docs.openstack.org/developer/devstack/guides/single-machine.html

_Actual official guide_
http://docs.openstack.org/havana/install-guide/install/apt-debian/content/basics-networking.html

mariaDB default password is 'root'
stack default password is 'stack'

Piece of code samplig local.conf
```bash
[[local|localrc]]
#Set FLOATING_RANGE to a range not used on the local network, i.e. 192.168.1.224/27. This configures IP addresses ending in 225-254 to be used as floating IPs.
FLOATING_RANGE=172.16.17..170/27
#Set FIXED_RANGE and FIXED_NETWORK_SIZE to configure the internal address space used by the instances.
FIXED_RANGE=172.16.17.215/32
FIXED_NETWORK_SIZE=1
#Set FLAT_INTERFACE to the Ethernet interface that connects the host to your local network. This is the interface that should be configured with the static IP address mentioned above.
FLAT_INTERFACE=eth0
#Default passwords
ADMIN_PASSWORD=stack
MYSQL_PASSWORD=root
RABBIT_PASSWORD=stack
SERVICE_PASSWORD=stack
```
