#!/bin/bash

root_path="$(cd "$(dirname "$0")" && pwd)"

# setup node.js repo
curl -sL https://deb.nodesource.com/setup_10.x | \
	sudo -E bash -

# add sublime text repo
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | \
	sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | \
	sudo tee /etc/apt/sources.list.d/sublime-text.list

# use Ubuntu firefox package
sudo cp $root_path/etc/apt/preferences.d/* /etc/apt/preferences.d/.

sudo apt-get update

sudo apt-get purge \
	firefox \
	gnome-calculator \
	hexchat \
	mintinstall \
	mintupdate \
	mintwelcome \
	rhythmbox \
	thunderbird \
	tomboy \
	transmission-gtk \
	xplayer

sudo apt-get autoremove

sudo apt-get install \
	build-essential \
	conky \
	firefox \
	git \
	htop \
	nodejs \
	speedcrunch \
	sublime-text \
	tree \
	vim

sudo apt-get clean

# install rust
curl https://sh.rustup.rs -sSf | \
	sh -s -- -y
