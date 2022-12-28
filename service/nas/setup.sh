#! /bin/bash

script_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function setup() {
	local name="$1"
	local service="nas-$1.service"

	mkdir -p "/nas/$name" \
		&& ln -sf "$script_path/$service" /etc/systemd/system/. \
		&& systemctl daemon-reload \
		&& systemctl enable --now "$service"
}

setup dubrowgn \
	&& setup shared
