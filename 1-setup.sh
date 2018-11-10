#!/bin/bash

root_path="$(cd "$(dirname "$0")" && pwd)"

cat "$root_path/home/.bashrc" >> "$HOME/.bashrc"
