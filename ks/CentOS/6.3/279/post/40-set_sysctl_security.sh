#!/bin/sh

echo "== Adding additional network security settings in /etc/sysctl.conf."

nowis=$(date +%Y%m%d-%H%M%S)

cat << EOF >> /etc/sysctl.conf

#-##
#-## Added by PXE build on $nowis
#-##

net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.tcp_max_syn_backlog = 1280
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.tcp_timestamps = 0
EOF

exit 0
