
# Notes about f123pi

## To install before release:

base
linux-raspberrypi
linux-raspberry-headers
openssh (enable service)
ntp (enable service)
espeak
tcl
emacs-nox (might change to emacs when stumpwm installed)
tclx (emacs dependency)
dosfstools (for mkfs.vfat
arch-install-scripts (for pacstrap)
alsa-utils
mplayer
ilctts
piespeakup


## Post arch-chroot

Note that all installs from AUR must not be as root.

yaourt (AUR)
tclx (AUR)
multipath-tools (AUR, for kpartx)

## Set Up

* Add udev rule to change permission on /dev/vchiq
* Do localization
* Create new user
* Set root password
* Install .emacs.d to both user home and /etc/skel
* Install our issue file to /etc
* Clear history for both new user and root
* Make sure there are no keys in user's .ssh/known_hosts
* Install imgtool, imgtool.lib, backupf123pi and bootstrapf123pi when finished
* Install expand and resize scripts to user home
* Install README to user home

