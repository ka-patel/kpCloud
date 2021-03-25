#!/bin/sh

echo "== Disable PCMCIA hardware."

echo "PCMCIA=no" > /etc/sysconfig/pcmcia

exit 0
