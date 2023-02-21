#! /bin/bash

remote_path="$1"
local_path="$2"

function ts() {
	date +%s.%3N
}

function dt() {
	echo "$(ts) - $1" | bc
}

function info() {
	echo "I - $@"
}

mountpoint "$local_path" &>/dev/null
if [[ "$?" == "0" ]]; then
	info "$local_path already mounted"
	exit 0
fi

info "mounting $remote_path @ $local_path..."
start="$(ts)"

sshfs \
		-f \
		-o ServerAliveInterval=1 \
		-o ConnectTimeout=3 \
		-o idmap=user \
		-o follow_symlinks \
		-o noatime \
		-o reconnect \
		-o max_conns=4 \
		"$remote_path" \
		"$local_path" \
	|| exit

info "mount succeeded in $(dt $start)s"
