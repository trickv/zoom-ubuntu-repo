#!/usr/bin/env bash

set -u
set -e

arch=amd64
deb_name=zoom_$arch.deb
rm -rf DEBIAN $deb_name
wget -q https://zoom.us/client/latest/$deb_name
dpkg -e $deb_name
version=$(cat DEBIAN/control | grep ^Version | cut -d\  -f2)
mv $deb_name zoom_${version}_$arch.deb
rm -rf DEBIAN $deb_name
