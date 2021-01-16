#!/bin/bash

sudo modprobe tcp_bbr
if ! grep tcp_bbr /etc/modules-load.d/modules.conf; then
	echo "tcp_bbr" | sudo tee -a /etc/modules-load.d/modules.conf
fi

if ! grep =bbr$ /etc/sysctl.conf; then
	#echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.conf
	sudo sysctl -p
fi
