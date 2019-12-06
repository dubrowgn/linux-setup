#!/bin/bash

function prompt() {
	local _msg="$1"

	echo "$_msg"
	select yn in "Yes" "No"; do
		case $yn in
		Yes ) return 0;;
		No ) return 1;;
		esac
	done
}

alias wget="wget -q --show-progress"
root_path="$(cd "$(dirname "$0")" && pwd)"

opt_in_packages=()

# setup node.js repo
curl -sL https://deb.nodesource.com/setup_13.x | \
	sudo -E bash -

# add sublime text repo
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | \
	sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | \
	sudo tee /etc/apt/sources.list.d/sublime-text.list

# add syncthing repo
wget -qO - https://syncthing.net/release-key.txt | \
	sudo apt-key add -
echo "deb https://apt.syncthing.net/ syncthing stable" | \
	sudo tee /etc/apt/sources.list.d/syncthing.list

if prompt "Install syncthing?"; then
	opt_in_packages+=("syncthing")
fi

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
	transmission-gtk

sudo apt-get autoremove

sudo apt-get dist-upgrade

sudo apt-get install \
	build-essential \
	conky-all \
	firefox \
	git \
	gparted \
	htop \
	httpie \
	jq \
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
	vlc \
	${opt_in_packages[@]}

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

# micro text editor
wget https://github.com/zyedidia/micro/releases/download/v1.4.1/micro-1.4.1-linux64.tar.gz
tar -xzf micro-1.4.1-linux64.tar.gz
mv micro-1.4.1/micro .
rm -rf micro-1.4.1

# pup
wget https://github.com/ericchiang/pup/releases/download/v0.4.0/pup_v0.4.0_linux_amd64.zip
unzip pup_v0.4.0_linux_amd64.zip
rm pup_v0.4.0_linux_amd64.zip

# renamer
wget "https://dubrowgn.com/media/renamer/files/renamer-latest (linux x64).zip" -O renamer.zip
unzip renamer.zip
rm renamer.zip
echo -e '#!'"/bin/bash\n\nQT_SCREEN_SCALE_FACTORS=2 /home/dubrowgn/.bin/$(ls renamer-*)" > renamer
chmod +x renamer*

cd ~/Downloads

# bat
wget https://github.com/sharkdp/bat/releases/download/v0.12.1/bat_0.12.1_amd64.deb
sudo dpkg -i bat_0.12.1_amd64.deb

# fd
wget https://github.com/sharkdp/fd/releases/download/v7.4.0/fd_7.4.0_amd64.deb
sudo dpkg -i fd_7.4.0_amd64.deb

# steam
if prompt "Install Steam client?"; then
	wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb
	sudo dpkg -i steam.deb
fi

