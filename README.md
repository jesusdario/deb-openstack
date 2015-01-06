# Repo for a debian single-machine OpenStack installer
Hacked Devstack!
I'll try to make of it as out-of-the-box as possible.

Run
```bash
# To install OpenStack Compute module
debstack.sh
# To load CirrOS on the cloud
try.sh
# To load global variables onto bash session
load-var.sh
# To uninstall OpenStack
uninstall.sh
```

*Links followed:*
* https://wiki.debian.org/OpenStackHowto/Essex
* https://packages.debian.org/wheezy/openstack-dashboard
* https://wiki.debian.org/OpenStack
* http://debian.netside.net/xps13_openstack.html
More recomendations:
* http://ispire.me/installing-openstack-on-debian-wheezy-single-node/
* http://docs.openstack.org/developer/devstack/guides/single-machine.html

I decided to include sublime-text 2 into the repo as I find it extremely light and useful.
'vm-machines' stores a CirrOS disk image, a very light OS for testing.
'colors.sh' imports a series of variables to provide a colourful prompt.

This script was developed as a tutorial for Advanced Telematic Services
at Universidad de Sevilla, by Jesús Darío Rivera Rubio.
