
# F123Pi

This is a work in progress.

Under development is code to:

* Bootstrap a new `.img` file containing a fully configured instance of `f123pi`.

The above is a process which is undertaken in stages:

1. `pacstrap` a base (bootable) image.
2. Add basic services such as sshd, dhcpcd, and ntp.
3. Install additional packages.
4. Install AUR packages (see below).

## AUR Packages

In order to automate the process of bootstrapping a new `f123pi` 
image, a custom repository is created and installed in the /opt 
directory of the host Pi.

Some basic packages wich are included in this custom repository are:

1. package-query
2. yaourt
3. multipath-tools
4. tclx (needed by emacspeak)
5. emacspeak
6. emacs-dot-d (contains tailored .emacs.d/ stuff)

## Full Documentation

Full documentation detailing how the whole image bootstrapping process 
is intended to work can be found in the `doc` sub-directory in the 
file named `bootstrap.md`.




