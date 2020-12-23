# About
**DO NOT INSTALL THIS ON A TUXEDO BOOK XA15 AS TUXEDO-TOMTE WILL HAVE ALREADY APPLIED THIS PATCH AUTOMATICALLY.**

The Clevo NH5xAx barebone has a bug, that causes cpufreq to not work on core 25-32 when a Ryzen 9 3950x is installed. This repo replaces the broken ssdt2 ACPI table, causing this bug, during boot. To archive this it uses the initramfs method (https://www.kernel.org/doc/html/v5.6/admin-guide/acpi/ssdt-overlays.html).

This repo supports Debians/Ubuntus update-initramfs script and OpenSUSEs mkinitrd/dracut script to patch the default initrd.img. Some distros, for example Arch, have other initrd.img build scripts. This repo will not work for these. Note that when you repack this fix for these distros, that the compiled aml file needs to be in an uncompressed section in the start of the initrd.img.

Author: Werner Sembach <wse@tuxedocomputers.com>

# Requirements
- initramfs-tools (Debian/Ubuntu) respectively dracut (OpenSUSE)
- acpica-tools (Debian/Ubuntu/OpenSUSE)

# Installation
These scripts must be run from a terminal.

Debian/Ubuntu: `sudo ./install_ubuntu.sh`

OpenSUSE: `sudo ./install_suse.sh`

# Uninstallation
These scripts must be run from a terminal.

Debian/Ubuntu: `sudo ./uninstall_ubuntu.sh`

OpenSUSE: `sudo ./uninstall_suse.sh`
