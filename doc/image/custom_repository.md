
# Custom repository

A custom repository is used in the generation of the f123pi image for 
the Raspberry Pi.

Currently this repository is local to the user creating an image.

## Pacman Configuration

in the `pacman` sub-directory of the top level of this repository 
there is a fragment of text to be added to the end of the 
`pacman.conf` used on the host on which an image is being built.

Here is the text of the fragment:

	[f123pi]
	SigLevel = Optional TrustAll
	Server = file:///opt/f123pi

This fragment of text should be added to the bottom of the 
`pacman.conf` file on the host Raspberry Pi.

After which it will be necessary to update the `pacman` cache, like 
this:

	sudo pacman -Sy

## Explanation

The `pacman.conf` fragment above names the custom repository by a 
combination of the `Server` entry and the string in the square 
brackets at the top of the entry.

In the above case the repository will be at:

	/opt/f123pi

Because the path is given by the `Server` string, and the repository 
will be called `f123pi`, given by the string in the square brackets.

## Creating the Custom Repository

The repository can be created by using the `repo-add` script installed 
on the host Raspberry Pi.

Example:

	repo-add /opt/f123pi/f123pi.db.tar.gz package.xz ...

Where `package.xz` is a package to add to the repository.

More than one package can be named on the command-line:

	repo-add /opt/f123pi/f123pi.db.tar.gz p1.xz p2.xz

## Removing a Package from the Repository

Removing a package from the repository is simple with the 
`repo-remove` script:

	repo-remove /opt/f123pi/f123pi.db.tar.gz unwanted-package.xz

## More help

For more help display the usage of the above two scripts:

	repo-add -h
	repo-remove -h

Or read the Arch Wiki.

## Custom Repository - Suggested Strategy

It is suggested that a custome repository should be created on a USB 
thumb drive, which can be mounted where the repository is needed:

	sudo mount /dev/sdx1 /opt/f123pi

Where `/dev/sdx` is the partition on the attached thumb drive which 
holds the repository.

It's also suggested that a USB drive be divided into two partitions 
and that it could be mounted on `/mnt` as follows:

	sudomount /dev/sdx1 /mnt/usb1
	sudo mount /dev/sdx2 /opt/f123pi

The first partition could be used for this repository, and the second 
partition for the custom repository.

In this way the user has a self-contained and portable mechanism for 
creating an f123pi image on a running f123pi Raspberry Pi.

An f123pi image is close to 2GB at the time of writing so a USB thumb 
drive is ideal for the extra space needed.

See the file `bootstrap.md` in this directory for instructions for how 
to create an image.

