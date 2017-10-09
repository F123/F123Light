#!/bin/bash

if [ `whoami` != 'root' ]; then
	echo "Must be run as root"
	exit 1
fi

set -e

repo_path="/opt/f123pi"
repo_name="f123pi.db.tar.gz"


repo-add ${repo_path}/${repo_name} ${repo_path}/*.pkg.tar.xz

exit 0

