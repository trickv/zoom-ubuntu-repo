#!/usr/bin/env bash

version="latest"
if [ "$1" != "" ]; then
    version=$1
fi

set -u
set -e

arch=$(dpkg --print-architecture)
echo "arch: ${arch}"
deb_name=zoom_$arch.deb
rm -f $deb_name
wget -q https://zoom.us/client/$version/$deb_name

version=$(dpkg -f ${deb_name} Version)
echo "Latest zoom version is $version"
target=zoom_${version}_$arch.deb
if [ -e $target ]; then
    echo "$target already exists. No action."
else
    echo "Adding $target to repository."
    mv $deb_name $target
    ./build-repo.sh
fi

rm -f $deb_name
