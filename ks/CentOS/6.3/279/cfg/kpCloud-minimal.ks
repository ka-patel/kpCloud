# https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Installation_Guide/s1-kickstart2-options.html



#version=DEVEL
install
text
#cmdline
#HTTP location of the disk media, the below path is an alias
# url --url http://kpCloud-ks/os/src/CentOS/6.3/279 --proxy http://kpCloud-ks:8000
url --url http://vault.centos.org/6.3/os/x86_64 --proxy http://kpCloud-ks:8000
lang en_US.UTF-8
keyboard us

## 
#
#  ++ NOTE by Kalpesh Patel ++
#
# LEAVE OUT THE NETWORK LINE -- the localbuild uses it to customize a local dev system 
# to build. Host name to the dev built is queried through iPXE/HTTP and passed on as a 
# URL parameter which generates a network line and appends to this file.
#
# -- default config of DHCP is fully present when building in cloud so no need to tell 
#    that here since default expects that. 

# network --onboot yes --bootproto dhcp --device eth0

rootpw  rootroot
sshpw --username=root rootroot --plaintext --lock

#Turn off firewall
firewall --disabled
authconfig --enableshadow --passalgo=sha512

#Set SELNUX to permissive
selinux --permissive
timezone --utc America/New_York
bootloader --location=mbr --driveorder=sda --append="crashkernel=auth max_loop=64"

# Make sure no space seperating items in the list
services --disabled iptables,ip6tables --enabled ntpdate,ntpd,atop

# The following is the partition information you requested
# Note that any partitions you deleted are not expressed
# here so unless you clear all partitions first, this is
# not guaranteed to work

#This forces the installer to overwrite the disk mbr or create it if this is first install
#If this is omitted the automatic install will prompt for input
zerombr 

#Clears all partition, insures install completes if rootvg
#already exists
clearpart --all --initlabel

#Creates the basic partitions, note the pv.01 is the association between
#a partition and LVM pv 
#Note sizes are in MB
part /boot --fstype=ext4 --size=256
part pv.01  --size=7424 --grow

volgroup vgOS pv.01
logvol / --fstype=ext4 --name=lvROOT --vgname=vgOS --size=2048 --grow
logvol swap --fstype=swap --name=lvSWAP --vgname=vgOS --size=1024
logvol /var --fstype=ext4 --name=lvVAR  --vgname=vgOS --size=512
# logvol /usr/local --fstype=ext4 --name=lvUSRLOCAL --vgname=vgOS --size=4096

reboot

# followig is MINIMAL https://partner-bugzilla.redhat.com/show_bug.cgi?id=593309
%packages --nobase
@core
@server-policy
wget
mc
git
 
%end


%pre --log=/tmp/kpCloud/ks/ks.pre.log
[ -n "$DEBUG" ] && set -x
exec < /dev/tty3 > /dev/tty3
chvt 3

echo
echo "+-----------------------------+"
echo "| Running Pre Configuration   |"
echo "+-----------------------------+"
echo

WRAPPER=wrapper.sh

set -a
PHASE=pre

CLIENTROOT=
KSROOT=$CLIENTROOT/tmp/kpCloud/ks
PHASEROOT=$KSROOT/$PHASE
mkdir -p $PHASEROOT

echo "getting $WRAPPER ..."
curl -v -o $PHASEROOT/$PHASE.sh http://kpCloud-ks/ks/helper/util/$WRAPPER
chmod u+x $PHASEROOT/$PHASE.sh
/bin/bash -x -c "cd $PHASEROOT ; ./$PHASE.sh 2>&1" 2>&1 | tee -a $PHASEROOT/$PHASE.log

chvt 1

%end

%post --log=/var/log/kpCloud/ks/ks.post.log
[ -n "$DEBUG" ] && set -x
exec < /dev/tty3 > /dev/tty3
chvt 3

echo
echo "+------------------------------+"
echo "| Running Post Configuration   |"
echo "+------------------------------+"
echo

WRAPPER=wrapper.sh

set -a
PHASE=post

CLIENTROOT=
KSROOT=$CLIENTROOT/var/log/kpCloud/ks
PHASEROOT=$KSROOT/$PHASE
mkdir -p $PHASEROOT

echo "getting $WRAPPER ..."
curl -v -o $PHASEROOT/$PHASE.sh http://kpCloud-ks/ks/helper/util/$WRAPPER
chmod u+x $PHASEROOT/$PHASE.sh
/bin/bash -x -c "cd $PHASEROOT ; ./$PHASE.sh 2>&1" 2>&1 | tee -a $PHASEROOT/$PHASE.log

chvt 1
%end 

%post --nochroot --log=/mnt/sysimage/var/log/kpCloud/ks/ks.post_noch.log
[ -n "$DEBUG" ] && set -x
exec < /dev/tty3 > /dev/tty3
chvt 3

echo
echo "+-----------------------------------------+"
echo "| Running Post Configuration (no chroot)  |"
echo "+-----------------------------------------+"
echo

WRAPPER=wrapper.sh

set -a
PHASE=post_noch

CLIENTROOT=/mnt/sysimage
KSROOT=$CLIENTROOT/var/log/kpCloud/ks
PHASEROOT=$KSROOT/$PHASE
mkdir -p $PHASEROOT

echo "getting $WRAPPER ..."
curl -v -o $PHASEROOT/$PHASE.sh http://kpCloud-ks/ks/helper/util/$WRAPPER
chmod u+x $PHASEROOT/$PHASE.sh
/bin/bash -x -c "cd $PHASEROOT ; ./$PHASE.sh 2>&1" 2>&1 | tee -a $PHASEROOT/$PHASE.log

chvt 1
%end
