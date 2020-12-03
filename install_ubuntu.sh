#!/bin/bash

if [ $(id -u) -ne "0" ]; then
  echo 'Please run as root'
  exit 1
fi

# Check if the device is the correct barebone
if ! grep -q NH5xAx "/sys/class/dmi/id/board_name"; then
    echo 'THIS DEVICE DOES NOT SEEM TO BE A "Clevo NH5xAx" BAREBONE.'
fi

# Warn the user and give him a last change to escape
echo 'THIS FIX MUST NOT BE INSTALLED ON ANYTHING ELSE THAN A "Clevo NH5xAx" BAREBONE!'
read -r -p "Only continue if you know what you are doing. Continue? [y/n]: " INPUT
 
case $INPUT in
  [yY][eE][sS]|[yY])
    ;;
  [nN][oO]|[nN])
    echo "Aborting."
    exit 0
    ;;
  *)
    echo "Invalid input."
    exit 1
    ;;
esac

# Check prerequisites
RET=0

if ! [ -x "$(command -v update-initramfs)" ]; then
  echo 'Error: initramfs-tools not installed. Please make sure that your distribution uses update-initramfs to build its initrd.img. If yes, you should be able to install initramfs-tools with your package manager.' >&2
  RET=1
fi

if ! [ -x "$(command -v iasl)" ]; then
  echo 'Error: acpica-tools not installed.' >&2
  RET=1
fi

if [ "$RET" -ne "0" ]; then
   exit 1
fi

# Start
cd $(dirname "$0")

# Build
iasl src/ssdt2.dsl
mv src/ssdt2.aml .

if ! [ -f "ssdt2.aml" ]; then
    echo 'Error: Build failed.' >&2
    exit 1
fi

# Install
mkdir -p /lib/firmware/tuxedo-corefix-clevo-nh5xax/
cp ssdt2.aml /lib/firmware/tuxedo-corefix-clevo-nh5xax/tuxedo-ssdt2.aml
cp ubuntu-setup/tuxedo-corefix-clevo-nh5xax /etc/initramfs-tools/hooks/
update-initramfs -u -k all

if ! lsinitramfs /boot/initrd.img | grep tuxedo-ssdt2.aml; then
    echo 'Error: Installation failed.' >&2
    exit 1
fi

exit 0
