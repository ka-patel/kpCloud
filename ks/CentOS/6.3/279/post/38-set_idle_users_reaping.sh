#!/bin/sh

idletime=$((24 * 60 * 60))
echo "== Setting idle timeout of $idletime seconds before logging them off."

echo "readonly TMOUT=${idletime}" >> /etc/profile.d/kpCloud-security.sh
echo "readonly HISTFILE" >> /etc/profile.d/kpCloud-security.sh
chmod +x /etc/profile.d/kpCloud-security.sh

exit 0
