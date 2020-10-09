#!/bin/bash

ZOOM_LINUX_URL="https://support.zoom.us/hc/en-us/articles/205759689-New-Updates-for-Linux"

TMP=$(mktemp /tmp/zoom-versions-XXXXXXXX)
wget -q -O "$TMP" "$ZOOM_LINUX_URL"

cat "$TMP"  | grep -oP '(?<=<strong>)[0-9\.]*(?=<br /></strong>)'
cat "$TMP"  | grep -oP '(?<=<strong>)[0-9\.]*(?=</strong>)'

rm "$TMP"
