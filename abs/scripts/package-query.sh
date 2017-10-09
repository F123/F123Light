#!/bin/bash

if [ `whoami` = 'root' ]; then
	echo "Script must NOT be run as root"
	exit 1
fi

set -e

git clone --depth 1 https://aur.archlinux.org/package-query.git
cd package-query
makepkg
