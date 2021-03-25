#!/bin/sh +x
echo "== Adding additional RPMS ..."

#-##
#-## The http_proxy Environment Variable
#-## 
#-## The http_proxy environment variable is also used by curl and other utilities. Although 
#-## yum itself may use http_proxy in either upper-case or lower-case, curl requires the name 
#-## of the variable to be in lower-case. 
#-##
#-## See http://www.centos.org/docs/5/html/yum/sn-yum-proxy-server.html
#-##

echo "   + Development"
rpms='git curl make'
http_proxy=http://kpCloud-ks:8000 yum -y --nogpgcheck --disableplugin=fastestmirror install $rpms

echo "   + Utilities"
rpms='atop htop iftop jnettop ftop vnstat iptraf nload dconf nmon ngrep whotrace dtrace multitail statgrab-tools lshw figlet banner p7zip pbzip2 lsscsi'
# openvt -s -w -v -- yum -y --nogpgcheck --noplugins install $rpms
http_proxy=http://kpCloud-ks:8000 yum -y --nogpgcheck --disableplugin=fastestmirror install $rpms

exit 0

