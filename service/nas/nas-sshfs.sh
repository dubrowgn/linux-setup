#! /bin/bash

remote_path="$1"
local_path="$2"

function info() {
	echo "I - $@"
}

mountpoint "$local_path" &>/dev/null
if [[ "$?" == "0" ]]; then
	info "$local_path already mounted; attempting to unmount..."
	fusermount -u "$local_path" \
		|| exit
fi

info "mounting $remote_path @ $local_path..."
sshfs \
		-f \
		-o auto_unmount \
		-o ServerAliveInterval=1 \
		-o ConnectTimeout=3 \
		-o idmap=user \
		-o follow_symlinks \
		-o noatime \
		-o max_conns=3 \
		"$remote_path" \
		"$local_path" \
	|| exit

info "unmounted $local_path"
