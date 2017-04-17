
# imgtool

This is currently a work in progress and the usage message displayed by imgtool may be out of date 
with the command-line options until it is finished.


imgtool will do the following:

* Create an empty .img file with two partitions, one which is FAT32, and the second which is ext4.
* Create loop devices and mount the two partitions somewhere in the file-system of the host Linux 
machine.

Or:

* Create loop devices and mount the two partitions of an existing Raspberry Pi image, such as a 
Raspbian image.

Or:

* Mount the two partitions of an SD card

It will also clean up after itself, un-mounting the two partitions, removing the loop devices and 
removing the mount points.

In this way it is possible, among other things to:

* Create a new empty .img file
* Mount both partitions of that file
* Mount both partitions of an existing Raspberry Pi image
* Un-mount both partitions of both .img files, remove the associated loop devices and remove the 
	mount points.
* Mount an SD card


