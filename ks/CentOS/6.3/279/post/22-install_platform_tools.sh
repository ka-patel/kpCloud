#!/bin/sh
echo "== Installing platform specific tools."

SysType=$(dmidecode -s system-product-name | sed -e 's/ //g')

echo "    \$SysType=$SysType"


function virtualbox { # - All that we need to do for Oracle's Virtual Box goes here
  dlname=virtualbox_tools.iso
  curl -v -o /tmp/${dlname} http://kpCloud-ks/ks/helper/src/GuestAdditions/VBoxGuestAdditions_4.3.0.iso
  isomnt=$(mktemp -d) 
  mount -o loop /tmp/${dlname} $isomnt

#-##   # We want individial history for the install so we can uninstall when done
#-##   for depname in make gcc; do
#-##     http_proxy=http://kpCloud-ks:8000 yum -y --nogpgcheck --disableplugin=fastestmirror install $depname
#-##   done

  http_proxy=http://kpCloud-ks:8000 yum -y --nogpgcheck --disableplugin=fastestmirror install make gcc
  ( cd $isomnt; ./VBoxLinuxAdditions.run )
  yum -y --nogpgcheck --setopt=clean_requirements_on_remove=1 remove gcc make

#-## #  yum -y --nogpgcheck --disableplugin=fastestmirror remove make gcc
#-##   for depname in make gcc ; do
#-##     histid=$(yum history list $depname | tail -n 1 | cut -d'|' -f1)
#-##     yum -y --nogpgcheck --disableplugin=fastestmirror history undo $histid
#-##   done

  umount -d $isomnt
  rmdir $isomnt
} # - End function virtualbox
 

function parallels { # - All that we need to do for Parallels goes here
  dlname=parallel_tools.iso
  curl -v -o /tmp/${dlname} http://kpCloud-ks/ks/helper/src/GuestAdditions/prl-tools-lin.iso 
  echo "Installing guest tools..."
  isomnt=$(mktemp -d) 
  mount -o loop /tmp/${dlname} $isomnt
  ( cd $isomnt; http_proxy=http://kpCloud-ks:8000 ./install --install-unattended-with-deps )
  umount -d $isomnt
  rmdir $isomnt
} # - End function parallels -


function vmware { # - All that we need to do for VMWare goes here
  http_proxy=http://kpCloud-ks:8000 yum -y --nogpgcheck --disableplugin=fastestmirror install vmware-tools-esx-nox
  for vmModule in pvscsi vmci vmhgfs vmmemctl vmxnet vmxnet3 vsock ; do
    # openvt -s -w -v -- yum --nogpgcheck --noplugins -y install kmod-vmware-tools-$vmModule
    http_proxy=http://kpCloud-ks:8000 yum -y --nogpgcheck --disableplugin=fastestmirror install kmod-vmware-tools-$vmModule
  done
} # - End function vmware -




case $SysType in
  ParallelsVirtualPlatform) 
    echo "Parallels virtual guest detected."
    parallels
  ;;
  VirtualBox)
    echo "VMware virtual guest detected."
    virtualbox
  ;;
  VMwareVirtualPlatform)
    echo "VMware virtual guest detected."
    vmware
  ;;
  *)
    exit 0
  ;;

esac

echo "    Turning of unnecessary hardware services..."
hwSvc='aldaemon kudzu mcstrans messagebus netfs restorecond mcelog'

for A in $hwSvc ; do 
  echo -n " $A"
  chkconfig $A off
done 

exit 0
