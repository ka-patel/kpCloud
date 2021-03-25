#!/bin/sh
echo "== Disabling quite boot up."

sed -i -e 's/rhgb//g' -e 's/quiet//g' /boot/grub/grub.conf

exit 0
