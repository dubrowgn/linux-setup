#!/bin/bash

alias wget="wget -q --show-progress"
root_path="$(cd "$(dirname "$0")" && pwd)"

# setup node.js repo
curl -sL https://deb.nodesource.com/setup_11.x | \
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

sudo apt-get dist-upgrade

sudo apt-get install \
	build-essential \
	conky \
	firefox \
	git \
	gparted \
	htop \
	keepass2 \
	nodejs \
	powertop \
	silversearcher-ag \
	smartmontools \
	speedcrunch \
	sublime-text \
	tree \
	tlp \
	vim \
	vlc

sudo apt-get clean

# install rust
curl https://sh.rustup.rs -sSf | \
	sh -s -- -y
source $HOME/.cargo/env
cargo install tcalc

mkdir -p $HOME/.bin
cd $HOME/.bin

# diff-so-fancy
wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
chmod +x diff-so-fancy

# renamer
wget "https://dubrowgn.com/media/renamer/files/Renamer [1.3.2 - linux64].zip" -O renamer.zip
unzip renamer.zip
rm renamer.zip
mv renamer-* renamer
chmod +x renamer

cd ~/Downloads

# bat
wget https://github.com/sharkdp/bat/releases/download/v0.7.1/bat_0.7.1_amd64.deb
sudo dpkg -i bat_0.7.1_amd64.deb

# fd
wget https://github.com/sharkdp/fd/releases/download/v7.1.0/fd_7.1.0_amd64.deb
sudo dpkg -i fd_7.1.0_amd64.deb

# steam
wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb
sudo dpkg -i steam.deb

