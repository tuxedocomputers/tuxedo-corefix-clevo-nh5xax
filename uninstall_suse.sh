#!/bin/bash

if [ $(id -u) -ne "0" ]; then
  echo 'Please run as root'
  exit 1
fi

# Check prerequisites
RET=0

if ! [ -x "$(command -v dracut)" ]; then
  echo 'Error: dracut not installed. Please make sure that your distribution uses mkinitrd+dracut to build its initrd.img. If yes, you should be able to install dracut with your package manager.' >&2
  RET=1
fi

if [ "$RET" -ne "0" ]; then
   exit 1
fi

# Uninstall
rm -rf /lib/firmware/tuxedo-corefix-clevo-nh5xax/
rm -rf /etc/dracut.conf.d/95-tuxedo-corefix-clevo-nh5xax.conf
mkinitrd

if lsinitrd /boot/initrd.img | grep -q tuxedo-ssdt2.aml; then
    echo 'Error: Uninstallation failed.' >&2
    exit 1
fi

exit 0
