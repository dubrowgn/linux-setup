#! /bin/bash

remote_path="$1"
local_path="$2"

timeo="4s"

function ts() {
	date +%s.%3N
}

function dt() {
	echo "$(ts) - $1" | bc
}

function info() {
	echo "I - $@"
}

function error() {
	echo "E - $@"
}

function mount_share() {
	mountpoint "$local_path" &>/dev/null
	if [[ "$?" == "0" ]]; then
		info "$local_path already mounted"
		return
	fi

	info "mounting $remote_path @ $local_path..."
	local start="$(ts)"

	timeout "$timeo" mount \
			-t cifs "$remote_path" "$local_path" \
			-o credentials=/root/creds.smb \
			-o uid=1000 \
			-o gid=1000 \
			-o iocharset=utf8 \
			-o file_mode=0755 \
			-o dir_mode=0775 \
			-o noperm \
			-o echo_interval=2 \
		|| return

	info "mount succeeded in $(dt $start)s"
}

function heartbeat() {
	local start="$(ts)"
	local n="$(ls -1 $local_path 2>/dev/null | wc -l)"
	if [[ "$n" -lt "1" ]]; then
		error "Failed heartbeat after $(dt $start)s"
		return 1
	fi

	return 0
}

function unmount_share() {
	info "unmounting $local_path..."
	local start="$(ts)"

	umount -lf "$local_path" \
		|| return

	info "unmount succeeded in $(dt $start)s"
}

mount_share \
	|| exit

running="1"
function on_sig() {
	running=""
}

trap on_sig SIGINT
trap on_sig SIGKILL
trap on_sig SIGTERM

while [[ "$running" != "" ]]; do
	sleep "$timeo"
	heartbeat \
		|| break
done

unmount_share
