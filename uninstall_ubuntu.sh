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

echo
echo 'Uninstallation succeeded.'

exit 0
