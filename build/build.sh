#!/bin/bash

# Automate Raspberry Pi image builds
# Take a config file on the command line and pass its options to the various stages of the build process

set -e

# Die if not running as root
[ $UID = 0 ] || { echo This script must run as root or via sudo.; exit 1; }

# The config file should be the only command line argument. We die if no config is specified.
if [ -f "$1" ]; then
	. "$1"
else
	echo No configuration file specified.
	echo Usage: sudo $0 \<configfile\>
	echo The following config files were found in this build directory:
	ls -1 *conf
	exit 1
fi

# All build stage scripts run from the scripts directory underneath the directory where this build script resides.
cd scripts

# Before building an image, we must be sure that the work directory does not exist.
# There is not yet a facility to complete a half-built failed image.
if [ -d "$workdir" ]; then
	./rpi-image-tool -C "$workdir" || true
	rm -R "$workdir"
fi

# Start by creating an empty image.
./rpi-image-tool -N "$imagename" -w "$workdir" -c "$imagesize" -b "$bootlabel" -r "$rootlabel"

# Bootstrap the OS
./bootstrap -l $packagelist -o $hostname -r "$rootpass" -u $username -p "$userpass" -s "$services" "${workdir}/root"

# Unmount the image file and remove the emptied work directory
./rpi-image-tool -C "$workdir"
rm -R "$workdir"

newrootsize=$(ls -hs "${imagename}" | cut -f1 -d' ')
echo $imagename was built successfully; echo
echo Size of $imagename is ${newrootsize}; echo
