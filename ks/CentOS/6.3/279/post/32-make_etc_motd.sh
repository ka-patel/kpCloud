#!/bin/sh
echo "== Creating /etc/motd banner."

IFS=-

set -- $(hostname)

echo $1 | tr '[:lower:]' '[:upper:]' | figlet -r -k -f mini -w 79 >> /etc/motd
echo $2 | tr '[:lower:]' '[:upper:]' | figlet -r -k -f mini -w 79 >> /etc/motd
echo $3 | tr '[:lower:]' '[:upper:]' | figlet -r -k -f mini -w 79 >> /etc/motd

shift 3

echo "$@" | tr '[:lower:]' '[:upper:]' | figlet -r -k -f mini -w 79 >> /etc/motd

exit 0
