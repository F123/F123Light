
# Arch Build System (ABS) Files

In this directory are files and scripts which relate to the creation 
of a custom Arch repository, and the generation of packages from 
PKGBUILD files, either downloaded from the AUR, other sources, or 
created manually.

## Sub-directories and Contents

# pacman/

In this directory is a file called `pacman.conf.fragment`. This should 
be added to the end of the `pacman.conf` on the host Pi being used to 
bootstrap a new f123pi image.

* scripts/

In the scripts directory are scripts which are used in the generation 
of Arch Linux packages and in the generation and maintenance of a 
custom repository used by the f123pi bootstrapping process.

