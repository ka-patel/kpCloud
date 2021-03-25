#!/bin/sh

echo "== Blacklisting wifi modules."

for i in $(find /lib/modules/`uname -r`/kernel/drivers/net/wireless -name "*.ko" -type f) ; do 
  echo "     $i"
  echo blacklist $i >> /etc/modprobe.d/blacklist-wireless.conf
done

exit 0
