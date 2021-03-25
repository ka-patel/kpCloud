#!/bin/sh

# to-do: http://www.idimmu.net/2009/10/20/creating-a-local-and-http-redhat-yum-repository/

# For other repos, see:
#  http://plone.lucidsolutions.co.nz/linux/centos
#  http://wiki.centos.org/AdditionalResources/Repositories

echo "== Adding external repos..."

# rpm -Uvh http://kpCloud-ks/ks/helper/src/elrepo-release-6-5.el6.elrepo.noarch.rpm
# rpm -Uvh http://kpCloud-ks/ks/helper/src/epel-release-6-8.noarch.rpm
# rpm -Uvh http://kpCloud-ks/ks/helper/src/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
# rpm -Uvh http://kpCloud-ks/ks/helper/src/nginx-release-centos-6-0.el6.ngx.noarch.rpm



# yum -y --nogpgcheck --noplugins install http://kpCloud-ks/ks/helper/src/elrepo-release-6-5.el6.elrepo.noarch.rpm
# yum -y --nogpgcheck --noplugins install http://kpCloud-ks/ks/helper/src/epel-release-6-8.noarch.rpm
# yum -y --nogpgcheck --noplugins install http://kpCloud-ks/ks/helper/src/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
# yum -y --nogpgcheck --noplugins install http://kpCloud-ks/ks/helper/src/nginx-release-centos-6-0.el6.ngx.noarch.rpm

yum -y --nogpgcheck --noplugins install elrepo-release epel-release rpmforge-release nginx-release city-fan.org-release

exit 0
