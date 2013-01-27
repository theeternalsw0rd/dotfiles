#!/usr/bin/env zsh
if [ -z "$TMUX" ]; then
	printf '\e]50;CursorShape=0\x7'
else
	printf '\ePtmux;\e\e]50;CursorShape=0\x7\e\\'
fi
#if [[ `uname` == 'Linux' ]]; then
#	if [ -z "$TMUX" ]; then
#		printf '\e[2 q'
#	else
#		printf '\ePtmux;\e\e[2 q\e\\'
#	fi
#fi
