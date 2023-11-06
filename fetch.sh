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
    echo "usage error: incorrect number of arguments or empty argument"
    exit 1
fi

arch="$(dpkg --print-architecture)"
echo "info: architecture ${arch}"
deb_name="zoom_${arch}.deb"
rm -f "${deb_name}"

# Here we download the file, but as it downloads we examine its header
# to grovel out the version, and if we already have that version the
# download is terminated early. The trick is to put the downloading
# process in the background, and then trickle the file being
# downloaded into a scanning process until enough has been seen to
# extract the version. And then decide what to do.

# Background this process:
curl --fail --silent --show-error --location "https://zoom.us/client/${version}/${deb_name}" > "${deb_name}" &

downloadpid=$!

# Snuffle through downloading file to extract version:
v="$(dpkg --field <(tail --retry --follow --pid=${downloadpid} --bytes=+0 "${deb_name}" 2>/dev/null) Version)"
echo "info: downloading zoom package has version ${v}"

target="zoom_${v}_${arch}.deb"

if [ -e "${target}" ]; then
    echo "info: aborting download, ${target} already exists."
    kill ${downloadpid}
    wait -f ${downloadpid} || true
    rm -f "${deb_name}"
else
    echo "info: waiting for download to complete."
    wait -f ${downloadpid} || true
    # This would be a good place to check the integrity of ${deb_name}
    # because an error in the downloading process, like a network fault,
    # could result in a truncated or corrupt file.
    echo "info: moving into place."
    mv "${deb_name}" "${target}"
    # rebuild repo if dpkg-scanpackages is available
    if type dpkg-scanpackages >/dev/null 2>&1  ; then
	echo "info: rebuilding repo."
	./build-repo.sh
    fi
fi

# install downloaded or existing package if appropriate
v0="$(apt-cache policy zoom | egrep '  Installed: ' | cut --delimiter=: --field=2 | tr -d ' ')"
if dpkg --compare-versions "${v0}" lt "${v}"; then
    read -p "install zoom ${v} over ${v0} [Y]? " a
    if [ -z "${a}" ] ; then
	sudo dpkg --install "${target}"
    fi
else
    echo "info: ${v} no newer than currently installed ${v0}"
fi
