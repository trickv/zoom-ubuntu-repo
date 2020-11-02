#!/usr/bin/env bash

set -f
set -u
set -e

if [ $# = 0 ]; then
    version="latest"
elif [ $# = 1 -a -n "$1" ]; then
    version="$1"
else
    echo "Usage: $0 [version]"
    echo "usage error: incorrect number or arguments or empty argument"
    exit 1
fi

arch="$(dpkg --print-architecture)"
echo "arch: ${arch}"
deb_name="zoom_${arch}.deb"
rm -f "${deb_name}"

# Here we download the file, but as it downloads we examine its header
# to grovel out the version, and if we already have that version the
# download is terminated early. The trick is to put the downloading
# process in the background, and then trickle the file being
# downloaded into a scanning process until enough has been seen to
# extract the version. And then decide what to do.

# Background this process:
wget --quiet --output-document=- "https://zoom.us/client/${version}/${deb_name}" > "${deb_name}" &

downloadpid=$!

# Snuffle through downloading file to extract version:
v="$(dpkg --field <(tail --retry --follow --pid=${downloadpid} --bytes=+0 "${deb_name}") Version)"
echo "info: downloading zoom package has version ${v}"

target="zoom_${v}_${arch}.deb"

if [ -e "${target}" ]; then
    echo "info: aborting download, ${target} already exists."
    kill $!
    wait -f
    rm -f "${deb_name}"
else
    echo "info: waiting for download to complete."
    wait -f
    echo "info: moving into place."
    mv "${deb_name}" "${target}"
    echo "info: rebuilding repo."
    ./build-repo.sh
fi
