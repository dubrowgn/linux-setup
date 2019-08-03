#! /bin/bash

auto=""
if [[ $1 == "-y" ]]; then
	auto="-y"
	shift
fi

version_filter=$1

version=$(apt-cache policy linux-image-$version_filter*-generic | \
	grep -o $version_filter.*-generic | \
	sort | \
	tail -1)

sudo apt-get install $auto \
	linux-image-$version \
	linux-headers-$version \
	linux-modules-$version \
	linux-modules-extra-$version
