#! /bin/bash

sudo apt install \
	libudev-dev \
	libusb-1.0-0 \
	libusb-1.0-0-dev \
	python3-dev \
	python3-docopt \
	python3-hid \
	python3-pip \
	python3-pkg-resources \
	python3-setuptools \
	python3-usb

pip3 install \
	liquidctl \
	wheel