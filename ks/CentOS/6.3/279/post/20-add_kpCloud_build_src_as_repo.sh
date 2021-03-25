#!/bin/sh
echo "== Adding a local repos pointing to kickstart sources."

# Create a file with the "here document" feature

todayis=$(date)
OS=$(IFS=/; set -- $ks; echo $5/$6/$7)

rpm --import http://kpCloud-ks/os/src/$OS
cat > /etc/yum.repos.d/kpCloud.repo <<EOF
#-## Created by PXE on ${todayis}

[kpCloud-OS]
name=kpCloud - $OS PXE Kickstart Build DVD
baseurl=http://kpCloud-ks/os/src/$OS
enabled=1
gpgcheck=0

[kpCloud-Helper]
name=kpCloud - PXE Build helper Repository
baseurl=http://kpCloud-ks/ks/helper/src
enabled=1
gpgcheck=0
EOF

yum clean all

exit 0
