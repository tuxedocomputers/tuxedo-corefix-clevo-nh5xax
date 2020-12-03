#!/bin/bash

if [ $(id -u) -ne "0" ]; then
  echo 'Please run as root'
  exit 1
fi

# Check prerequisites
RET=0

if ! [ -x "$(command -v update-initramfs)" ]; then
  echo 'Error: initramfs-tools not installed. Please make sure that your distribution uses update-initramfs to build its initrd.img. If yes, you should be able to install initramfs-tools with your package manager.' >&2
  RET=1
fi

if [ "$RET" -ne "0" ]; then
   exit 1
fi

# Uninstall
rm -rf /lib/firmware/tuxedo-corefix-clevo-nh5xax/
rm -rf /etc/initramfs-tools/hooks/tuxedo-corefix-clevo-nh5xax
update-initramfs -u -k all

if lsinitramfs /boot/initrd.img | grep tuxedo-ssdt2.aml; then
    echo 'Error: Uninstallation failed.' >&2
    exit 1
fi

exit 0
