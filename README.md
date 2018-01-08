# F123Light
## Build system for F123 on Raspberry Pi 2 and 3 computers

# Introduction
The F123Light build system is a collection of scripts and custom files used to build F123Light images that can be written to a MicroSD card for use on a [Raspberry Pi](https://www.raspberrypi.org/) computer, either model 2 or 3. F123Light on a Raspberry Pi 3 runs in 32-bit mode, because it includes the vendor supplied kernel and boot code, which are said to be more stable than the 64-bit mainline kernel and U-boot at this time. However, with modifications to the package list file used, it is also possible to configure the build system for 64-bit mode if desired.
# Compatibility
This build system started as an adaptation of the [f123pi](https://github.com/f123/f123pi) build system, but it is largely rewritten for better compatibility and functionality on a wider variety of configurations. The f123pi build system required images to be built using a working Raspberry Pi. This version is capable of building working images on any ARMv7 or later computer running [ArchLinuxARM](https://archlinuxarm.org/). Experimental development builds using this system are currently being performed on a Raspberry Pi 3 and an Odroid C2, but any 32-bit ARM machine using the armv7h architecture or any 64-bit machine using the aarch64 architecture may be used to build F123Light images, as long as the machine is running an ArchLinuxARM compatible OS with the needed packages. On the other hand, images built using this system will only run on the Raspberry Pi 2 and 3, though this build system can certainly be adapted to build images for other devices with little difficulty.
# Dependencies
In order to build images using this system, you will need the following Arch packages:
* util-linux: for partition and loop device support, (installed on most systems)
* parted: for writing and manipulating partitions, installed on most systems
* arch-install-scripts: to bootstrapp the OS into a mounted image, (most likely not preinstalled)
* dbus: to set gsettings keys if a graphical desktop is being configured, (a dependency of systemd, installed on most systems)
The build script will automatically install any dependencies it finds missing.
# Installation
No installation beyond the dependencies listed above is required in order to use this build system. Just clone the git repository, cd into the build directory, usually F123Light/build and run the build script as described below.
# The Build Directory
The build directory consists of the following components:
* build.sh: the primary automated build script
* *.conf: contains options used when building images
* package_lists: A directory containing lists of packages that can be installed into an image
* files: A repository of modified files to be copied to an image during the build
* scripts: build stage scripts that take options passed into them by build.sh, but can also run separately
* utils: utility scripts used for localization of the build system
# Using Build.sh
The build.sh script builds an image automatically, based on values in the configuration file specified on its command line. It must run as root.

Usage:
  sudo ./build.sh <configuration-file>

Only one argument needs to be supplied on the build.sh command line. This is the single configuration file needed to build an image. The script will take all the options in the configuration file and automatically create an empty image, mount it, download and install officially available packages, optionally build and install AUR packages, set any needed gsettings keys, copy in modified files, configure the new system, enable systemd services, unmount the image and cleanup the work directory based on those options.

The configuration file argument must always be supplied. If not, a usage message is displayed and all available configuration files are listed for convenience. If more than one configuration is specified, a usage message is displayed and the script exits.
# The Configuration File
The automated build.sh script takes a configuration file on its command line. At least one configuration file is included in this repository.

This is a basic example of a configuration file. It is well commented to allow for easy editing and to give an understanding of the available options.
  # F123Light configuration
  # The lines below, in key=value format, will set options to be passed to various stages of the image building process.
  # This file will be sourced by build.sh in the same directory, and can contain anything that a shell can execute.
  
  # The version count - the first of the day should be 1, increment this manually for the imagename and rootlabel counters
  count=1
  
  # The working directory where the new image is to be mounted - must be an absolute path
  workdir=${PWD}/F123Light
  
  #The full path and filename of the Raspberry Pi image file 
  imagename="${PWD}/F123Light-MATE-en_US-$(date +%y.%m.%d)-${count}.img"
  
  # The size of the image file in MB, for example 8192 will create an 8GB zero-filled image file
  imagesize=7168
  
  # The volume label of the FAT32 filesystem on the boot partition - must be <= 11 bytes
  bootlabel=F123-boot
  
  # The volume label of the ext4 filesystem on the root partition - must be <= 16 bytes
  rootlabel="F123Light$(date +%y%m%d)${count}"
  
  # Set this on a graphical desktop that uses gsettings: MATE, GNOME, etc.
  # Remove or comment the line below if the image is to run in text mode with no desktop or window manager, or one that is not compatible with gsettings.
  gsettings=1
  
  # The full path to the file listing official packages to be installed to the new system
  packagelist="${PWD}/package_lists/F123Light/MATE.list"
  
  # The full path to the file listing AUR packages to be installed to the new system.
  aurlist="${PWD}/package_lists/F123Light/fenrir.aur.list"
  
  # The hostname of the new system
  hostname=f123light
  
  # The root password
  rootpass=root
  
  # The name of the regular user
  username=f123
  
  # The regular user's password
  userpass=f123
  
  # The system locale/language
  locale=en_US.UTF-8
  
  # A list of services to be enabled once the OS is installed
  services="dhcpcd ntpd sshd NetworkManager lxdm"
# Package Caching
During the automated build process, all officially available packages are cached under the working directory where the image is mounted. This optimizes both for image size and speed of any build after the first build, which must download all packages that are to be installed. First, the package cache is stored outside the image, which saves space when transferring the image, especially over the internet, because even if the cache is deleted from the image itself, the data is still present, making its total space usage on disk larger. Storing the cache outside of the image eliminates this problem, because package files are never stored inside of the mounted image at all, thereby making its total space usage on disk smaller. Secondly, storing the cache outside of the image makes the package cache persistent, even if an image is deleted. For example, an image is built with the MATE desktop on Tuesday, and a text only image is built on Thursday. The MATE image was deleted on Wednesday, but will be built again with small modifications on Friday. The MATE image contains all the packages used on the base system. Because a persistent cache is used, even though the MATE image has been deleted, no packages will be downloaded either on Thursday or Friday, unless a new package has been added to the list or a package has been updated in the repository, because they already exist in the cache. On the other hand, cache size can eventually become unwieldy, because multiple versions of packages may be stored in the cache. If the cache is taking too much disk space, root may delete it at any time, either by removing the pacman-cache directory under the work directory or by recursively removing the work directory. This of course will delete the entire cache, so all packages will need to be downloaded again the next time an image is built.
