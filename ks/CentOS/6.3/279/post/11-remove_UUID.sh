#!/bin/sh
echo "== Removing UUID lines from interface files."

sed -i '/UUID=/d' /etc/sysconfig/network-scripts/ifcfg-eth*

exit 0
