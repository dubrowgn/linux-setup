#! /bin/bash

function override() {
	local old_path="$(which "$1")"
	local new_path="$(which "$2")"

	sudo mv -n "$old_path" "$old_path.old" &&
	sudo ln -s "$new_path" "$old_path"
}

function unoverride() {
	local path="$(which "$1")"

	if ! readlink "$path" > /dev/null; then
		echo "$path is not a link!"
		return 1
	fi

	sudo rm "$path" &&
	sudo mv -n "$path.old" "$path"
}

if [[ "$1" == "-u" || "$1" == "--undo"  ]]; then
	unoverride bzip2 \
	&& unoverride bunzip2 \
	&& unoverride gzip \
	&& unoverride gunzip \
	&& unoverride xz \
	|| exit
else
	sudo apt install lbzip2 pigz pxz zstd \
	&& override bzip2 lbzip2 \
	&& override bunzip2 lbunzip2 \
	&& override gzip pigz \
	&& override gunzip unpigz \
	&& override xz pxz \
	|| exit

	# unxz is a link to xz anyway
fi

ls -l --color "$(which bzip2)"
ls -l --color "$(which bunzip2)"
ls -l --color "$(which gzip)"
ls -l --color "$(which gunzip)"
ls -l --color "$(which xz)"
