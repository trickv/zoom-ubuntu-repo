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
wget -q https://cdn.zoom.us/prod/$version/$deb_name
dpkg -e $deb_name
version=$(cat DEBIAN/control | grep ^Version | cut -d\  -f2)
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
