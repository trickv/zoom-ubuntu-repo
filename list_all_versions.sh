#!/bin/bash
set -e

ZOOM_LINUX_URL="https://support.zoom.us/hc/en-us/articles/205759689-New-Updates-for-Linux"

TMP=$(mktemp --tmpdir zoom-versions-XXXXXXXX)
wget --quiet --output-document=- "$ZOOM_LINUX_URL" >> "$TMP"

grep -oP '(?<=<strong>)[0-9\.]*(?=<br /></strong>)'		< "$TMP" || true
grep -oP '(?<=<strong>)[0-9\.]*(?=</strong>)'			< "$TMP" || true

rm -f "$TMP"
