#!/bin/bash
# build.sh
# Automate Raspberry Pi image builds
# Take a config file on the command line and pass its options to the various stages of the build process
#
# Copyright 2018, F123 Consulting, <information@f123.org>
# Copyright 2018, Kyle, <kyle@free2.ml>
#
# This is free software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free
# Software Foundation; either version 3, or (at your option) any later
# version.
#
# This software is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this package; see the file COPYING.  If not, write to the Free
# Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA.
#
#--code--

export TEXTDOMAIN=build.sh
export TEXTDOMAINDIR=./locale

. gettext.sh

set -e
# Load the common functions
. scripts/functions

# Die if not running as root
if ! check_root ; then
	PROGNAME=$0
	echo $(eval_gettext "Script must be run as root, try: sudo \$PROGNAME") ; echo
	exit 1
fi

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
# todo: Call the loaded functions as needed rather than calling the stage scripts.
# First, the current directory must be saved.
current=$PWD

# Now we enter the directory where the stage scripts live.
cd scripts

# Check for dependencies and install any that are missing.
check_deps

# Before building an image, we must be sure that the work directory is clean except for a package cache.
# There is not yet a facility to complete a half-built failed image, but we can cache software packages.
if [ -d "$workdir" ]; then
	clean_up "$workdir" || true
	# Don't remove an otherwise empty work directory if a pacman cache is present
	[ -d "${workdir}/pacman-cache" ] || rm -R "$workdir"
fi

# Start by creating an empty image and mounting it.
new_image $workdir $imagename $bootlabel $rootlabel boot root $imagesize 1M 64M

# Install packages available from the official ALARM repositories.
./pacstrap -l "$packagelist"  -c "${workdir}/pacman-cache" "$workdir/root"

# Set the system hostname
echo $hostname > $workdir/root/etc/hostname

# The root partition is automatically mounted by systemd. Add only the boot partition information to fstab.
echo -e "\n/dev/mmcblk0p1  /boot   vfat    defaults        0       0" >> $workdir/root/etc/fstab

# Set the root password
set_password "${workdir}/root" root "${rootpass}"

# Install locale specific packages. The file name looks like the configured package list file, but includes an @ sign followed by the locale followed by .list, e.g. packages@sw_KE.list.
# This file will be ignored if it doesn't exist.
test -f "${packagelist%%.list}@${locale}.list" && ./pacstrap -l "${packagelist%%.list}@${locale}.list" -c "${workdir}/pacman-cache" "$workdir/root"

# Add the regular user and set its password
add_user "${workdir}/root" "${username}"
set_password "${workdir}/root" "${username}" "${userpass}"

# Install packages from the AUR
# This is optional, and will only run if an AUR package list is set in the config file passed to this script.
test $aurlist && ./aur-install -l "$aurlist" "${workdir}/root"

# Copy any override files into the new system. This overrides any system and user configuration files or scripts installed with packages.
cp -R ../files/* "${workdir}/root/" || true

# Set the system locale. This must be set before we can copy user files to $HOME.
set_locale $workdir/root $locale

# Always copy the contents of /etc/skel to the home directory of the user that was created earlier
systemd-nspawn -a -q -D $workdir/root\
	sudo -u \#1000\
	bash -c "shopt -s dotglob && cp -R /etc/skel/* \"\$HOME\""

# Enable system services
for service in $services; do
	manage_service "${workdir}/root" enable "${service}"
done

# Set gsettings keys to enable Orca
# This is optional, and cannot run on a text only system.
[ $gsettings ] && ./gsettings "${workdir}/root"

# Configure wifi if network information is present in the configuration file.
test $wifi && setup_wifi $workdir/root ${wifi[@]}

# Touch the firstboot file. It will be deleted by the firstboot script that looks for it.
systemd-nspawn -a -q -D $workdir/root\
	sudo -u \#1000\
	bash -c "touch \$HOME/.firstboot"

# Unmount the image file
clean_up "$workdir"
# Keep the work directory if a pacman cache exists, otherwise remove it
[ -d "${workdir}/pacman-cache" ] || rm -R "$workdir"

# Once all scripts have completed, come back to the directory from which this script was launched.
cd $current

newrootsize=$(ls -hs "${imagename}" | cut -f1 -d' ')
relativeimage=$(realpath --relative-to="$PWD" "$imagename")
echo $relativeimage was built successfully; echo
echo Size of $relativeimage is ${newrootsize}; echo
