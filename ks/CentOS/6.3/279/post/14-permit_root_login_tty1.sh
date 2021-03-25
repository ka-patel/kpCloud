#!/bin/sh

echo "== Restricting root login to tty1 only and restricting root's home directory."

echo "tty1" > /etc/securetty
chmod 700 /root

exit 0
