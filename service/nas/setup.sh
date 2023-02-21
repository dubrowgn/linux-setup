#! /bin/bash

# https://wiki.archlinux.org/title/Systemd/User

script_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
service_path="$HOME/.local/share/systemd/user"

function setup() {
	local name="$1"
	local remote_path="$2"
	local local_path="$3"

	cat "$script_path/template.service" \
		| sed "s|{{local_path}}|$local_path|" \
		| sed "s|{{remote_path}}|$remote_path|" \
		| sed "s|{{service_path}}|$service_path|" \
		> "$service_path/nas-$name.service" \
		&& mkdir -p "$local_path" \
		&& systemctl --user daemon-reload \
		&& systemctl --user enable --now "nas-$name.service"
}

user="$(whoami)"

mkdir -p "$service_path" \
	&& cp "$script_path/nas-sshfs.sh" "$service_path/." \
	&& setup "personal" "$user@dubrowgn-srv:/nas/$user" "$HOME/Personal" \
	&& setup "shared" "leeroy@dubrowgn-srv:/nas/shared" "$HOME/Shared"
