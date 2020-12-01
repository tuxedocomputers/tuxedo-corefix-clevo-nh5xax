The Clevo NH5xAx barebone has a bug, where cpufreq does not work on core 25-32 when a Ryzen 9 3950x is installed. This repo replaces the broken ssdt2 ACPI table, causing this bug, during boot. To archive this it uses the initramfs method.

This repo uses Debians/Ubuntus update-initramfs script to patch the default initrd.img. Some distros, for example Arch, have other initrd.img build scripts. This repo will not work for these. Note that when you repack this fix for these distros, that the compiled aml file needs to be in an uncompressed section in the start of the initrd.img.
