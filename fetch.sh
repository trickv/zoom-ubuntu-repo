#!/usr/bin/env bash

version="latest"
if [ "$1" != "" ]; then
    version=$1
fi

set -u
set -e

arch=amd64
deb_name=zoom_$arch.deb
rm -rf DEBIAN $deb_name
wget -q https://zoom.us/client/$version/$deb_name

dpkg -e $deb_name
#
# Removed unnecessary processing since vesion can be directly obtained using dpkg -f debname Version.
#
#version=$(cat DEBIAN/control | grep ^Version | cut -d" " -f2)
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

rm -rf DEBIAN $deb_name
