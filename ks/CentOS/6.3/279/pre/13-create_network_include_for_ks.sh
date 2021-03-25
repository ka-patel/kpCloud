#!/bin/sh -x
echo "== Creating network line for kickstart."

< /proc/cmdline sed -e 's/ /\n/g' | grep '=' > /tmp/kpCloud/ks/cmdline
. /tmp/kpCloud/ks/cmdline

if [ "x$localbuild" == "x" ] ; then
  echo "network --device eth0 --bootproto dhcp" > /tmp/kpCloud/ks/network.ks
else
  echo "network --device eth0 --bootproto dhcp --hostname $localbuild" > /tmp/kpCloud/ks/network.ks
  hostname $localbuild
fi
  
exit 0
