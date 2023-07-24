#!/bin/bash

alias cat="batcat --style plain --paging never"
alias clear="clear && clear"
alias diff="diff --color"
alias fd="fdfind -uu -E .git"
alias make="make -j$((2 * $(nproc)))"
alias rg="rg -uu -g \!.git"
alias zstd="zstd -T$(nproc)"

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

function regex() {
	local _ml=false;
	local _spat="";
	local _rpat=false;
	local _path="";

	while [[ $# > 0 ]]; do
		case "$1" in
		"-p" | "--path")
			shift;
			if [[ $# == 0 ]]; then
				echo "Expected path";
				return 1;
			fi
			_path="$1" && shift;
			;;
		"-ml" | "--multi-line")
			_ml=true && shift;
			;;
		"-r" | "--replace")
			shift;
			if [[ $# == 0 ]]; then
				echo "Expected replace pattern";
				return 1;
			fi
			_rpat="$1" && shift;
			;;
		*)
			if [[ "$_spat" != "" ]]; then
				echo "Unexpected argument \"$1\"";
				return 1;
			fi

			_spat="$1" && shift;
			;;
		esac
	done

	local _ag_prefix="";
	local _ml_arg="";
	local _rx_opts="";
	if [[ $_ml == true ]]; then
		_ag_prefix="(?s)";
		_ml_args="-0";
		_rx_opts="sm";
	fi

	local _path_arg="";
	if [[ "$_path" != "" ]]; then
		_path_arg="-G $_path";
	fi

	if [[ $_rpat != false ]]; then
		ag "$_ag_prefix$_spat" $_path_arg --files-with-matches | \
			xargs -I {} \
			perl $_ml_args -pi -e "s/$_spat/$_rpat/g$_rx_opts" {};
	else
		ag "$_ag_prefix$_spat" $_path_arg;
	fi
}
