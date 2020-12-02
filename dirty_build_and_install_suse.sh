#!/bin/bash

# Temporary install script until a package format is decided

# Build
iasl src/ssdt2.dsl
mv src/ssdt2.aml .

# Install
mkdir -p /lib/firmware/tuxedo-corefix-clevo-nh5xax/
cp ssdt2.aml /lib/firmware/tuxedo-corefix-clevo-nh5xax/tuxedo-ssdt2.aml
cp config/95-tuxedo-corefix-clevo-nh5xax-suse.conf /etc/dracut.conf.d/
mkinitrd
