#!/bin/sh
echo "== Adding proxying to yum."

echo "proxy=http://kpCloud-ks:8000/" >> /etc/yum.conf

exit 0
