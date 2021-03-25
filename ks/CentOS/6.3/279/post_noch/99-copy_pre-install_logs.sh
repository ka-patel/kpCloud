#!/bin/sh

SRC=/tmp/kpCloud/ks
DEST=$KSROOT

echo "== Copying pre install logs to final log location."
echo "  \$SRC=$SRC"
echo " \$DEST=$DEST"

tar -C $SRC -cf - . | tar -C $DEST -xvf -

exit 0
