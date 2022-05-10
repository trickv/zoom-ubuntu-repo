# zoom-ubuntu-repo
Scripts to build a Debian/Ubuntu compatible repository from Zoom's published .deb files

This is hardcoded for zoom amd64 builds but can easily be modified for i386 if you want it.

# Simple usage

Adapt the paths in zoom-update.cron for your needs and add it to your cron jobs:

```
linux # cp zoom-update.cron /usr/local/bin/zoom-update.cron
linux # echo '0 * * * * nobody /usr/local/bin/zoom-update.cron' > /etc/cron.d/zoom-update
```

# Background

Parsing the Zoom homepage got harder and harder, but here's what I got as a workaround from Zoom:
(mind the URL containing the current version number):

```
linux # wget --spider https://zoom.us/client/latest/zoom_amd64.deb | grep ^Location:
Spider mode enabled. Check if remote file exists.
--2022-02-01 07:49:17--  https://zoom.us/client/latest/zoom_amd64.deb
Resolving zoom.us (zoom.us)... 170.114.10.74
Connecting to zoom.us (zoom.us)|170.114.10.74|:443... connected.
HTTP request sent, awaiting response... 302 
Location: https://cdn.zoom.us/prod/5.9.3.1911/zoom_amd64.deb [following]
Spider mode enabled. Check if remote file exists.
--2022-02-01 07:49:17--  https://cdn.zoom.us/prod/5.9.3.1911/zoom_amd64.deb
Resolving cdn.zoom.us (cdn.zoom.us)... 99.84.89.248
Connecting to cdn.zoom.us (cdn.zoom.us)|99.84.89.248|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 56825388 (54M) [binary/octet-stream]
Remote file exists.
```

So in order to get the latest version number, do this:

```
linux # wget --spider https://zoom.us/client/latest/zoom_amd64.deb 2>&1 | grep ^Location: | sed -e 's/.*prod\/\(.*\)\/.*/\1/'
5.9.3.1911
```
