#!/bin/sh

basedir=/etc/kpCloud.d/etc/sudoers.d
conffile=/etc/sudoers.d/kpCloud

echo "== Changing sudo configuration to include central repo."
echo '  $basedir='${basedir}
echo ' $conffile='${conffile}

oldIFS=$IFS

IFS=- 
set -- $(hostname)

IFS=$oldIFS
group=$(echo $4 | sed "s/[0-9][0-9]$//g")
todayis=$(date) 
  
# Files needs to be 0440 perms and dirs need to be 0755 perms
umask u=r,g=r,o=

# Get the sudo into /etc/kpCloud.d/etc/sudoers.d tree from central repo
git clone -b master http://kpCloud-git.kpcloud.org/kpCloud/sudo-conf.git ${basedir}


cat <<EOF >>$conffile

#-## 
#-## Created by PXE on ${todayis}
#-##  

EOF

# Include subs dirs.
for sudohostdir in 'global' $1 $1-$2 $1-$2-$3 $1-$2-$3-$group $1-$2-$3-$4 ; do
  fullsudohostdir=${basedir}/${sudohostdir}
  echo '    $fullsudohostdir='$fullsudohostdir
  echo "#includedir ${fullsudohostdir}" >> $conffile
  mkdir -p $fullsudohostdir
done

IFS=$oldIFS

sudodir=$basedir

find $sudodir -mindepth 1 -not -iwholename '*.git*' -type d -exec chmod u=rwx,g=rx,o=rx {} \;

until [ -z $sudodir ] ; do
  echo '$sudodir='$sudodir
  chmod u=rwx,g=rx,o=rx $sudodir
  sudodir=${sudodir%/*}
done

exit 0
