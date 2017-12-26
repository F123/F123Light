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

# Before building an image, we must be sure that the work directory is clean except for a package cache.
# There is not yet a facility to complete a half-built failed image, but we can cache software packages.
if [ -d "$workdir" ]; then
	./rpi-image-tool -C "$workdir" || true
	# Don't remove an otherwise empty work directory if a pacman cache is present
	#[ -d "${workdir}/pacman-cache" ] || rm -R "$workdir"
fi

# Start by creating an empty image.
./rpi-image-tool -N "$imagename" -w "$workdir" -c "$imagesize" -b "$bootlabel" -r "$rootlabel"

# Install packages available from the official ALARM repositories.
./pacstrap -l "$packagelist"  -c "${workdir}/pacman-cache" "$workdir/root"

# Configure the base system: hostname, username, passwords, services
./config-base -o $hostname -r "$rootpass" -u $username -p "$userpass" -s "$services" "${workdir}/root"

# Install packages from the AUR
# This is optional, and will only run if an AUR package list is set in the config file passed to this script.
[ $aurlist ] && ./aur-install -l "$aurlist" "${workdir}/root"

# Set gsettings keys to enable Orca
# This is optional, and cannot run on a text only system.
[ $desktopaccess ] && ./orca-gsettings "${workdir}/root"

# Unmount the image file
./rpi-image-tool -C "$workdir"
# Keep the work directory if a pacman cache exists, otherwise remove it
#[ -d "${workdir}/pacman-cache" ] || rm -R "$workdir"

# Once all scripts have completed, come back to the directory from which this script was launched.
cd $OLDPWD

newrootsize=$(ls -hs "${imagename}" | cut -f1 -d' ')
relativeimage=$(realpath --relative-to="$PWD" "$imagename")
echo $relativeimage was built successfully; echo
echo Size of $relativeimage is ${newrootsize}; echo
