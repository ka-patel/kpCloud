#!/bin/sh

echo "== Disable IP v6 stack by disabling ipv6 module."

touch /etc/modprobe.d/disable-ipv6.conf
echo "install ipv6 /bin/true" >> /etc/modprobe.d/disable-ipv6.conf

exit 0
