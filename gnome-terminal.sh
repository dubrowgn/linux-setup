#!/bin/bash

word_chars="-_"
profile=`gsettings get org.gnome.Terminal.ProfilesList default | tr -d \'`

echo "Updating default profile '$profile' ..."

dconf write \
	"/org/gnome/terminal/legacy/profiles:/:$profile/word-char-exceptions" \
	"@ms \"$word_chars\""
