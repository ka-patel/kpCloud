#!/bin/sh
echo "== Converting DHCP config into static config."

DEVICE=`route -n|grep '^0.0.0.0'|awk '{print $8}'`
IPADDR=`ifconfig $DEVICE|grep 'inet addr:'|awk '{sub(/addr:/,""); print $2}'`
NETMASK=`ifconfig $DEVICE|grep 'Mask'|awk '{sub(/Mask:/,""); print $4}'`
NETWORK=`ipcalc $IPADDR -n $NETMASK|awk -F= '{print $2}'`
GATEWAY=`route -n|grep '^0.0.0.0'|awk '{print $2}'`
HWADDR=`ifconfig $DEVICE|grep 'HWaddr'|awk '{print $5}'`

todayis=$(date)

cat <<EOF >/etc/sysconfig/network
#-## 
#-## Created by PXE on ${todayis}
#-## 
NETWORKING=yes
HOSTNAME=$HOSTNAME
GATEWAY=$GATEWAY
EOF

cat <<EOF >/etc/sysconfig/network-scripts/ifcfg-$DEVICE
#-## 
#-## Created by PXE on ${todayis}
#-## 
DEVICE=$DEVICE
BOOTPROTO=static
IPADDR=$IPADDR
NETMASK=$NETMASK
ONBOOT=yes
HWADDR=$HWADDR
EOF

exit 0
