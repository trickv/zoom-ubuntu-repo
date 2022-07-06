#!/bin/bash
set -e

#ZOOM_LINUX_URL="https://support.zoom.us/hc/en-us/articles/205759689-New-Updates-for-Linux"
ZOOM_LINUX_URL="https://support.zoom.us/hc/en-us/articles/205759689"

TMP=$(mktemp --tmpdir zoom-versions-XXXXXXXX)
#wget --quiet --output-document=- "$ZOOM_LINUX_URL" >> "$TMP"
# Zoom web page is now protected by cloudflare
# This requires a more clever download util (usually called browser)
w3m -dump_source "$ZOOM_LINUX_URL" | gzip -cd >> "$TMP"

grep -oP '(?<=<strong>)[0-9\.]*(?=<br /></strong>)'		< "$TMP" || true
grep -oP '(?<=<strong>)[0-9\.]*(?=</strong>)'			< "$TMP" || true
(grep -oP '[0-9]+\.[0-9]+\.+[0-9]+\ \([0-9]+\.[0-9]+\)' | sed -e s+'\.[0-9]* ('+'.'+ -e s+')'+''+)	\
								< "$TMP" || true
# New format: "5.8.0 (16)"
(grep -oP '[0-9]+\.[0-9]+\.+[0-9]+\ \([0-9]+\)' | sed -e s+' ('+'.'+ -e s+')'+''+)			\
								< "$TMP" || true

rm -f "$TMP"
