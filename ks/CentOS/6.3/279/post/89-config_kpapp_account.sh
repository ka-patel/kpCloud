#!/bin/sh

username=kpapp

echo "== Creating shadow root user ($username) account and setting up for git access via SSH."

groupadd -o -g 0 $username
useradd -m -d /home/$username -u 0 -g $username -o -c "kpCloud Application Shadow Account" -r $username

echo "== Setting up for git access via SSH keys for kpapp user."

umask u=rwx,g=,o=
mkdir -pv ~root/.ssh/keys/kpCloud-git

cp -v {/etc/kpCloud.d/etc/ssh,~root/.ssh}/keys/kpCloud-git/git

exit 0
