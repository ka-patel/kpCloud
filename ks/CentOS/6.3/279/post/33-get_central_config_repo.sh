#!/bin/sh

echo "== Getting central config repo of configurations."

# Get the top level (/etc/kpCloud.d/etc) configuration
repodest=/etc/kpCloud.d
echo '  $repodest='${repodest}

umask u=rwx,g=rx,o=rx
git clone -b master http://kpCloud-git.kpcloud.org/kpCloud/host-conf.git ${repodest}

exit 0
