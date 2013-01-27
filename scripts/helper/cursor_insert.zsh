#!/usr/bin/env zsh
if [ -z "$TMUX" ]; then
	printf '\e]50;CursorShape=1\x7'
else
	# remote session could be either run both to be safe
	printf '\ePtmux;\e\e]50;CursorShape=1\x7\e\\'
	printf '\ePtmux;\e\e[6 q\e\\'
fi
#if [[ `uname` == 'Linux' ]]; then
#	if [ -z "$TMUX" ]; then
#		printf '\e[6 q'
#	else
#		printf '\ePtmux;\e\e[6 q\e\\'
#	fi
#fi
