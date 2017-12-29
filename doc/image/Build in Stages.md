# Building an Image in Stages
This document describes how to use the build stage scripts to perform a more manual build.
# Introduction
Normally, in order to build an F123Light image for a Raspberry Pi computer, the script at build/build.sh is used, along with the configuration file that has the desired options configured. *See README.md at the top level of this repository for full documentation of the automated build process.* This document describes a more manual build that offers better control of the build process by using the stage scripts in build/scripts individually, using command line options rather than a configuration file. It is assumed that each script will be called from the build/scripts directory in this repository. Each script must be run as root, either as the logged in user or via sudo. Script calls in this document are written for sudo users; if not using sudo, just remove sudo from the beginning of the command line.
# rpi-image-tool
This script creates, mounts, unmounts and manipulates two-partition Raspberry Pi image files.
## usage
sudo ./rpi-image-tool <operation> <argument> [options]
### Operations, arguments and options
*-N <imagefile> -w <workdirectory> -c <blockcount> [-z blocksize] [-s <split>] [-b <bootlabel>] [-r <rootlabel>]*  
Create a new image with the given filename and parameters, then mount it.  
-w <workdirectory>  
The work directory where the image is mounted. Package caches are also stored under this directory.  
-z <blocksize>  
The block size used when writing the empty image file. May be a number of bytes or a number with a K, M or G suffix, representing kilobytes, megabytes or gigabytes. Default is 1MB.  
-c <count>  
The number of blocks to be written to the empty image file.  
-s <split>  
Determines the size of the boot partition. May be a number of bytes or a number of kilobytes, megabytes or gigabytes, suffixed by K, M or G. Default is 64MB.  
-b <bootlabel>  
Specify the volume label of the boot partition. Default is rpi-boot.  
-r <rootlabel>  
Specify the volume label of the root partition. Default is rpi-root.  
*-M <imagefile> -w <workdirectory>*  
Mount the specified image file under the specified work directory.  
*-D <device> -w <workdirectory>*  
Mounts the specified device under the specified work directory. Device must be a two-partition Raspberry Pi image.  
*-C <workdirectory>*  
Unmounts a mounted image and cleans up the specified work directory, with the exception of package caches, which are always preserved.
*-h*  
Currently not fully implemented: display usage message.
