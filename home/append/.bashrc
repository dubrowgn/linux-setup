
# custom

shopt -s nullglob
for f in "$HOME/.bash/"*; do
	source "$f"
done
shopt -u nullglob
