
# custom

export PATH="$HOME/.bin:$PATH"
export PS1="\[\e[37m\e[1m\]\u\[\e[95m\]@\[\e[37m\]\h \[\e[95m\]\W\[\e[37m\] $\[\e[m\] "
export TIMEFORMAT="real: %2Rs; user: %2Us; system: %2Ss; cpu: %P%%"

for f in "$HOME/.bash/"*; do
	source "$f"
done
