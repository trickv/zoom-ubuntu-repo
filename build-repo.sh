#!/usr/bin/env bash

dpkg-scanpackages -m . | gzip > Packages.gz
