#!/bin/bash

set -e

if [ -z $AFP_LOGIN ]; then
    echo "no AFP_LOGIN specified!"
    exit 1
fi

if [ -z $AFP_PASSWORD ]; then
    echo "no AFP_PASSWORD specified!"
    exit 1
fi

if [ -z $AFP_NAME ]; then
    echo "no AFP_NAME specified!"
    exit 1
fi

# Add the user
useradd $AFP_LOGIN -M
echo $AFP_LOGIN:$AFP_PASSWORD | chpasswd

echo "/data/timemachine \"${AFP_NAME}\" allow:${AFP_LOGIN} options:usedots,upriv,tm cnidscheme:dbd" >> /etc/netatalk/AppleVolumes.default

if [ -n "$AFP_SIZE_LIMIT" ]; then
    echo "
    volsizelimit: ${AFP_SIZE_LIMIT}" >> /etc/netatalk/AppleVolumes.default
fi

echo "[${AFP_NAME}]
      comment = Time Machine
      path = /data/timemachine
      browseable = yes
      writeable = yes
      read only = no
      guest ok = yes" >> /etc/samba/smb.conf

# Initiate the timemachine daemons
# The path of the timemachine must be synchornized with the assignment in Dockerfile
chown -R $AFP_LOGIN:$AFP_LOGIN /data/timemachine

# Update AFP_NAME to afpd.service
sed -Ei s/__AFP_NAME__/$AFP_NAME/g /etc/avahi/services/afpd.service

# fixed dbus bug with wrong path of dbus-daemon configuring in /etc/init.d/dbus
if [ ! -f /usr/bin/dbus-daemon ]; then
    ln -sf /bin/dbus-daemon /usr/bin/dbus-daemon
fi

# Launch server for running timemachine
/etc/init.d/dbus start
/etc/init.d/avahi-daemon start
/etc/init.d/netatalk start
/etc/init.d/samba restart

# wait indefinetely
while true
do
  tail -f /dev/null & wait ${!}
done

