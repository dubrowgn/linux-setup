#!/bin/bash

alias cat="batcat --style plain --paging never"
alias clear="clear && clear"
alias diff="diff --color"
alias fd="fdfind -uu -E .git"
alias make="make -j$((2 * $(nproc)))"
alias rg="rg -uu -g \!.git"
alias zstd="zstd -T$(nproc)"
