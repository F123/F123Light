#!/bin/bash
       
xgettext -L Shell -o - \
bootstrap-f123pi \
pacstrap-f123pi \
pacstrap-f123pi.lib \
config-base-f123pi | \
sed -e 's|YEAR|2017|' \
-e 's|=CHARSET|=UTF-8|' \
-e 's|SOME DESCRIPTIVE TITLE|bootstrap-f123pi|' \
-e "s|THE PACKAGE'S COPYRIGHT HOLDER|Mike Ray|" \
-e 's|FIRST AUTHOR|Mike Ray|' \
-e 's|EMAIL@ADDRESS|mike.ray@btinternet.com|' \
-e 's|PACKAGE VERSION|0.1.0alpha|' \
-e 's|FULL NAME|Mike Ray|' \
> bootstrap-f123pi.pot



