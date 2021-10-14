#!/bin/bash

#ZOOM_LINUX_URL="https://support.zoom.us/hc/en-us/articles/205759689-New-Updates-for-Linux"
ZOOM_LINUX_URL="https://support.zoom.us/hc/en-us/articles/205759689"

TMP=$(mktemp /tmp/zoom-versions-XXXXXXXX)
#wget -q -O "$TMP" "$ZOOM_LINUX_URL"
# Zoom web page is now protected by cloudflare
# This requires a more clever download util (usually called browser)
w3m -dump_source "$ZOOM_LINUX_URL" | gzip -cd > "$TMP"

cat "$TMP"  | grep -oP '(?<=<strong>)[0-9\.]*(?=<br /></strong>)'
cat "$TMP"  | grep -oP '(?<=<strong>)[0-9\.]*(?=</strong>)'
cat "$TMP"  | grep -oP '[0-9]+\.[0-9]+\.+[0-9]+\ \([0-9]+\.[0-9]+\)' | sed -e s+'\.[0-9]* ('+'.'+ -e s+')'+''+
# New format: "5.8.0 (16)"
cat "$TMP"  | grep -oP '[0-9]+\.[0-9]+\.+[0-9]+\ \([0-9]+\)' | sed -e s+' ('+'.'+ -e s+')'+''+

rm "$TMP"
