#!/bin/sh
echo "== Linking /etc/issue to central repo version."

mv -f /etc/issue{,.orig}
ln -s {/etc/kpCloud.d,}/etc/issue

exit 0
