#!/bin/bash
# Copyright (c) 2020 TUXEDO Computers GmbH <tux@tuxedocomputers.com>
#
# This file is part of TUXEDO CoreFix for Clevo NH5xAx.
#
# This file is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# TUXEDO CoreFix for Clevo NH5xAx is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with TUXEDO CoreFix for Clevo NH5xAx.  If not, see <https://www.gnu.org/licenses/>.

if [ $(id -u) -ne "0" ]; then
  echo 'Please run as root'
  exit 1
fi

# Check if the device is the correct barebone
if ! grep -q NH5xAx "/sys/class/dmi/id/board_name"; then
    echo 'THIS DEVICE DOES NOT SEEM TO BE A "TUXEDO XA15" OR ANOTHER DEVICE BASED ON A "Clevo NH5xAx" BAREBONE.'
fi

# Warn the user and give him a last change to escape
echo 'THIS FIX MUST NOT BE INSTALLED ON ANYTHING ELSE THAN A "TUXEDO XA15" OR ANOTHER DEVICE BASED ON A "Clevo NH5xAx" BAREBONE!'
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
  echo 'Error: dracut not installed. Please make sure that your distribution uses mkinitrd+dracut to build its initrd. If yes, you should be able to install dracut with your package manager.' >&2
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
iasl src/nh5xax.dsl
mv src/nh5xax.aml .

if ! [ -f "nh5xax.aml" ]; then
    echo 'Error: Build failed.' >&2
    exit 1
fi

# Install
mkdir -p /lib/firmware/tuxedo-corefix-clevo-nh5xax/
cp nh5xax.aml /lib/firmware/tuxedo-corefix-clevo-nh5xax/
cp suse-setup/95-tuxedo-corefix-clevo-nh5xax.conf /etc/dracut.conf.d/
mkinitrd

if ! lsinitrd | grep -q nh5xax.aml; then
    echo 'Error: Installation failed.' >&2
    exit 1
fi

echo
echo 'Installation succeeded.'

exit 0
