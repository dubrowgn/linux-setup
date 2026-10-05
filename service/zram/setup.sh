#!/bin/bash
# See: https://ubuntuhandbook.org/index.php/2024/08/enable-zram-ubuntu/

script_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
service_path="/etc/systemd/system"

mem=$(grep MemTotal /proc/meminfo | grep -Po '\d+')
[[ $? == 0 ]] || exit

udev="ACTION==\"add\", KERNEL==\"zram0\", ATTR{disksize}=\"${mem}K\""

echo "zram" | sudo tee /etc/modules-load.d/zram.conf \
	& echo "$udev" | sudo tee /etc/udev/rules.d/99-zram.rules \
	& sudo modprobe zram \
	& sudo cp "$script_path/zram.service" "$service_path/." \
	& sudo systemctl daemon-reload \
	& sudo systemctl enable --now "zram.service" \
	& zramctl
