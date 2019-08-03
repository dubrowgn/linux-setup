#! /bin/bash

version_filter=$1

versions=$(apt-cache policy linux-image-$version_filter*-generic | \
	grep -B 1 "Installed: $version_filter" | \
	grep -o $version_filter.*-generic | \
	sort)

packages=""
for v in $versions; do
	packages="$packages linux-image-$v linux-headers-$v linux-modules-$v linux-modules-extra-$v"
done

sudo apt-get remove $packages

