#!/usr/bin/env bash

versions=()

versions+=("2.1.103753.0521")
versions+=("2.3.128305.0716")
versions+=("2.4.121350.0816")
versions+=("2.4.129780.0915")
versions+=("2.6.146750.1204")
versions+=("2.6.149990.1216")
versions+=("2.7.162522.0121")
versions+=("2.8.222599.0519")

for version in ${versions[@]}; do
    echo "Fetching zoom $version"
    ./fetch.sh $version
done
