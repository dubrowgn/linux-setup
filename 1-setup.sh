#!/bin/bash

root_path="$(cd "$(dirname "$0")" && pwd)";
home_path="$root_path/home";

copy_path="$home_path/copy";
for f in $(ls -A $copy_path); do
	cp -Ri "$copy_path/$f" "$HOME/$f";
done

append_path="$home_path/append";
for f in $(ls -A $append_path); do
	cat "$append_path/$f" >> "$HOME/$f";
done
