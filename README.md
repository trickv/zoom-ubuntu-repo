# zoom-ubuntu-repo
Scripts to build a Debian/Ubuntu compatible repository from Zoom's published .deb files

This is hardcoded for zoom amd64 builds but can easily be modified for i386 if you want it.

# Scripts
* historical.sh will fetch a list of old versions of zoom builds and stick them in the current directory
* fetch.sh will fetch a single version, or whatever the latest version is from zoom.us even if it's a new release
* build-repo.sh builds a simple repository using dpkg-scanpackages

# How to use
* Clone this
* Run ./historical.sh
* Run ./fetch.sh if there's a newer version upstream
* Run ./build-repo.sh
* Put these files on a web server somewhere
* Adapt zoom-repo-example.list to point to your server
* apt-get update && apt-get install zoom
  * and apt-get upgrade in the future will pull in updates

# Update:

As parsing the homepage gets harder and harder, here's what I got as a workaround from Zoom:
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
