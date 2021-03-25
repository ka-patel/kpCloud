#!/bin/sh

echo "== Disabling CTRL-ALT-DELETE combo to reboot."

# perl -npe 's/ca::ctrlaltdel:\/sbin\/shutdown/#ca::ctrlaltdel:\/sbin\/shutdown/' -i /etc/inittab

perl -npe 's+^exec /sbin/shutdown+#exec /sbin/shutdown+' -i /etc/init/control-alt-delete.conf 
echo 'exec echo "Control-Alt-Delete disabled."' >> /etc/init/control-alt-delete.conf 

exit 0
