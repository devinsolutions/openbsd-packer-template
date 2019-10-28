#!/bin/ksh

# Network
rm /etc/hostname.*
echo 'dhcp' > /etc/hostname.vio0

# Serial console
echo 'stty com0 115200' > /etc/boot.conf
echo 'set tty com0'    >> /etc/boot.conf
sed -i -e 's/^tty00[[:space:]]\(.*\)[[:space:]]unknown off$/tty00   \1   vt220   on  secure/' \
  /etc/ttys

# GCE packages
pkg_add google-compute-engine
echo 'rcctl enable google_compute_engine' > /etc/rc.firsttime
