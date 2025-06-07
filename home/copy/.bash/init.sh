#!/bin/bash

alias cat="batcat --style plain --paging never"
alias clear="clear && clear"
alias diff="diff --color"
alias fd="fdfind -uu -E .git"
alias make="make -j$((2 * $(nproc)))"
alias rg="rg -uu -g \!.git"
alias zstd="zstd -T$(nproc)"

export PATH="$HOME/.bin:$PATH"
export PS1="\[\e[37m\e[1m\]\u\[\e[95m\]@\[\e[37m\]\h \[\e[95m\]\W\[\e[37m\] $\[\e[m\] "
export TIMEFORMAT="real: %2Rs; user: %2Us; system: %2Ss; cpu: %P%%"
