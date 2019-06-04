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
