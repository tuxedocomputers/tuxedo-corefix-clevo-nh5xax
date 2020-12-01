#!/bin/bash

# Temporary install script until a package format is decided

# Build
iasl src/ssdt2.dsl
mv src/ssdt2.aml .

# Install
mkdir -p /lib/firmware/tuxedo-corefix-clevo-nh5xax/
cp ssdt2.aml /lib/firmware/tuxedo-corefix-clevo-nh5xax/
cp hooks/tuxedo-corefix-clevo-nh5xax /etc/initramfs-tools/hooks
update-initramfs -u -k all
