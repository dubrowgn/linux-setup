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

function upstream-distro() {
	cat "/etc/upstream-release/lsb-release" | \
		grep "CODENAME" | \
		awk '{split($0,a,"="); print a[2]}'
}

function sudo-pipe() {
	sudo tee "$1" > /dev/null
}

function apt-src-add() {
	local name="$1"
	local key_url="$2"
	local src="$3"

	local key_path="/usr/share/keyrings/$name.gpg"
	local src_path="/etc/apt/sources.list.d/$name.list"

	wget -qO - "$key_url" | gpg --dearmor | sudo-pipe "$key_path" \
		&& echo "deb [signed-by=$key_path] $src" | sudo-pipe "$src_path"
}

function apt-ppa-add() {
	local name="$1"
	local dist="$2"

	function fprint() {
		curl -s "https://api.launchpad.net/1.0/~$name/+archive/ubuntu/$dist" \
			| grep -oP 'signing_key_fingerprint":\s*"[^"]+' \
			| grep -oP '[0-f]+$'
	}

	apt-src-add "$name" \
		"https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x$(fprint)" \
		"http://ppa.launchpad.net/$name/$dist/ubuntu $(upstream-distro) main"
}

opt_in_packages=()

# setup node.js repo
curl -sL https://deb.nodesource.com/setup_current.x | \
	sudo -E bash -

# add sublime text repo
apt-src-add "sublime-text" \
		"https://download.sublimetext.com/sublimehq-pub.gpg" \
		"https://download.sublimetext.com/ apt/stable/" \
	|| exit

if prompt "Install syncthing?"; then
	apt-src-add "syncthing" \
			"https://syncthing.net/release-key.gpg" \
			"https://apt.syncthing.net/ syncthing stable" \
		|| exit

	opt_in_packages+=("syncthing")
fi

if prompt "Install RetroArch?"; then
	apt-ppa-add "libretro" "stable" \
		|| exit

	opt_in_packages+=("retroarch")
fi

if prompt "Add proprietary graphics apt repo?"; then
	apt-ppa-add "graphics-drivers" "ppa" \
		|| exit
fi

if prompt "Add open graphics apt repo?"; then
	apt-ppa-add "oibaf" "graphics-drivers" \
		|| exit
fi

sudo apt-get update \
	&& sudo apt-get purge \
		celluloid \
		gnome-calculator \
		hexchat \
		mintinstall \
		mintreport \
		mintupdate \
		mintwelcome \
		rhythmbox \
		thunderbird \
		tomboy \
		transmission-gtk \
		warpinator \
	&& sudo apt-get autoremove \
	&& sudo apt-get dist-upgrade \
	&& sudo apt-get install \
		bat \
		build-essential \
		conky-all \
		fd-find \
		gdebi \
		gimp \
		git \
		git-lfs \
		gparted \
		htop \
		httpie \
		inkscape \
		jq \
		keepass2 \
		micro \
		nodejs \
		parallel \
		powertop \
		silversearcher-ag \
		smartmontools \
		speedcrunch \
		sublime-text \
		tree \
		tlp \
		vim \
		vlc \
		xclip \
		${opt_in_packages[@]} \
	&& sudo apt-get clean \
	|| exit

# install rust
curl https://sh.rustup.rs -sSf | \
	sh -s -- -y
source $HOME/.cargo/env
RUSTFLAGS="-C target-cpu=native" cargo install broot tcalc

mkdir -p $HOME/.bin
cd $HOME/.bin

# diff-so-fancy
wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
chmod +x diff-so-fancy

# pup - https://github.com/ericchiang/pup/issues/129
wget https://github.com/ericchiang/pup/releases/download/v0.4.0/pup_v0.4.0_linux_amd64.zip
unzip pup_v0.4.0_linux_amd64.zip
rm pup_v0.4.0_linux_amd64.zip

# telegram
if prompt "Install Telegram client?"; then
	wget https://telegram.org/dl/desktop/linux -O telegram.tar.xz
	tar -xvf telegram.tar.xz
	rm telegram.tar.xz
fi

cd ~/Downloads

# renamer
wget https://github.com/dubrowgn/renamer/releases/download/v1.4.0/renamer-1.4.0-0_amd64.deb
sudo apt install ./renamer-1.4.0-0_amd64.deb
echo -e '#!'"/bin/bash\n\nQT_SCREEN_SCALE_FACTORS=2 /usr/local/bin/renamer" > ~/.bin/renamer
chmod +x ~/.bin/renamer

# steam
if prompt "Install Steam client?"; then
	wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb
	sudo dpkg -i steam.deb
fi
