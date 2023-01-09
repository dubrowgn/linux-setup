
# custom

export PATH="$HOME/.bin:$PATH"
export PS1="\[\e[37m\e[1m\]\u\[\e[95m\]@\[\e[37m\]\h \[\e[95m\]\W\[\e[37m\] $\[\e[m\] "

for f in "$HOME/.bash/"*; do
	source "$f"
done
