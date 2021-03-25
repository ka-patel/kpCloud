#!/bin/sh

echo "== Creating list of rpms installed."

logdir=/var/log/kpCloud/rpm_listing

mkdir -p ${logdir}
yum  --noplugins list installed 2>&1 >${logdir}/pxe.lst
