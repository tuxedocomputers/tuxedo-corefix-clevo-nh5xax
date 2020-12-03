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

if ! [ -x "$(command -v dracut)" ]; then
  echo 'Error: dracut not installed. Please make sure that your distribution uses mkinitrd+dracut to build its initrd.img. If yes, you should be able to install dracut with your package manager.' >&2
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
iasl src/tuxedo-ssdt2.dsl
mv src/tuxedo-ssdt2.aml .

if ! [ -f "tuxedo-ssdt2.aml" ]; then
    echo 'Error: Build failed.' >&2
    exit 1
fi

# Install
mkdir -p /lib/firmware/tuxedo-corefix-clevo-nh5xax/
cp tuxedo-ssdt2.aml /lib/firmware/tuxedo-corefix-clevo-nh5xax/
cp suse-setup/95-tuxedo-corefix-clevo-nh5xax.conf /etc/dracut.conf.d/
mkinitrd

if ! lsinitrd /boot/initrd.img | grep -q tuxedo-ssdt2.aml; then
    echo 'Error: Installation failed.' >&2
    exit 1
fi

echo
echo 'Installation succeeded.'

exit 0
