#!/bin/sh
echo "== Removing MAC address lines from interface files."

sed -i '/HWADDR=/d' /etc/sysconfig/network-scripts/ifcfg-eth*

exit 0
