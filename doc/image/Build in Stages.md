# Building an Image in Stages #
This document describes how to use the build stage scripts to perform a more manual build.
# Introduction #
Normally, in order to build an F123Light image for a Raspberry Pi computer, the script at build/build.sh is used, along with the configuration file that has the desired options configured. *See README.md at the top level of this repository for full documentation of the automated build process.* This document describes a more manual build that offers better control of the build process by using the stage scripts in build/scripts individually, using command line options rather than a configuration file. It is assumed that each script will be called from the build/scripts directory in this repository. Each script must be run as root, either as the logged in user or via sudo. Script calls in this document are written for sudo users; if not using sudo, just remove sudo from the beginning of the command line. It is also recommended that these scripts be called in the order listed below, but the build system is tolerant of some deviations from this order, as well as multiple calls in some cases. For example, it is possible to run gsettings either before or after aur-install, but the non-root user is required in order to build AUR packages or set gsettings keys, so config-base must run before either aur-install or gsettings. On the other hand, pacstrap may run any number of times using the same mount point, at any point in the build process, as long as its first run comes before config-base, as config-base requires at least a minimal system to be installed.
# rpi-image-tool #
This script creates, mounts, unmounts and manipulates two-partition Raspberry Pi image files.
## usage ##
  ./rpi-image-tool -h
  sudo ./rpi-image-tool <operation> <argument> [options]
## Operations, arguments and options ##
**-N <imagefile> -w <workdirectory> -c <blockcount> [-z blocksize] [-s <split>] [-b <bootlabel>] [-r <rootlabel>]**  
Create a new image with the given filename and parameters, then mount it.  
*-w <workdirectory>*  
The work directory where the image is mounted. Package caches are also stored under this directory.  
*-z <blocksize>*  
The block size used when writing the empty image file. May be a number of bytes or a number with a K, M or G suffix, representing kilobytes, megabytes or gigabytes. Default is 1MB.  
*-c <count>*  
The number of blocks to be written to the empty image file.  
*-s <split>*  
Determines the size of the boot partition. May be a number of bytes or a number of kilobytes, megabytes or gigabytes, suffixed by K, M or G. Default is 64MB.  
*-b <bootlabel>*  
Specify the volume label of the boot partition. Default is rpi-boot.  
*-r <rootlabel>*  
Specify the volume label of the root partition. Default is rpi-root.

**-M <imagefile> -w <workdirectory>**  
Mount the specified image file under the specified work directory.

**-D <device> -w <workdirectory>**  
Mount the specified device under the specified work directory. Device must be a two-partition Raspberry Pi image.

**-C <workdirectory>**  
Unmount a mounted image and cleanup the specified work directory, with the exception of package caches, which are always preserved.

**-h**  
Currently not fully implemented: display usage message.
# pacstrap #
This script installs packages to a mounted image or to the directory of your choice.
## Usage ##
  ./pacstrap -h
  sudo ./pacstrap [-d] [-c <cachedirectory>] -l <packagelist> <systemroot>
## Options and Arguments ##
*-d*  
Install packages to a directory rather than a mount point.

*-c <cachedirectory>*  
Use <cachedirectory> to store the persistent package cache.

*-l <packagelist>*  
Install all packages listed in <packagelist.

*<systemroot>*  
The top level root of the installed system. Must be a mount point, unless *-d* is specified.

*-h*  
Currently not fully implemented: display usage message.
# config-base #
Configures the base system, including  the hostname, root password, non-root username/password and system services.
## Usage ##
./config-base -h  
sudo ./config-base [-o <hostname] [-r <rootpassword>] [-u <username>] [-p <userpassword>] [-s <services>] <systemroot>
## Options and Arguments ##
*-o <hostname>*  
The hostname of the installed system. Default is alarmpi.

*-r <rootpassword>*  
The password of the root user. Default is root.

*-u <username>*  
The username of the non-root user. Default is alarm.

*-p <userpassword>*  
The password of the non-root user. Default is alarm.

*-s <services>*  
A quoted list of system services to be enabled on the installed system at boot time.

*systemroot>*  
The top level root of the installed system.

*-h*  
Currently not fully implemented: display usage message.
# aur-install #
Builds and installs packages from the Arch User Repository (AUR), using the specified package list.
## Usage ##
./aur-install -h  
sudo ./aur-install -l <packagelist> <systemroot>
## Options and arguments ##
*-l <packagelist>*  
The file containing the list of packages to be built and installed.

*<systemroot>*  
The top level root directory of the installed system.
*-h*  
Currently not fully implemented: display usage message.
# gsettings #
Sets various gsettings keys. This script must only be run if a gsettings compatible desktop has been installed.
## usage ##
sudo ./gsettings <systemroot>
## Options and Arguments ##
*<systemroot>*  
The top level root directory of the installed system.
