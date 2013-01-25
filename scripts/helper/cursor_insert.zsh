#!/usr/bin/env zsh
if [[ `uname` == 'Darwin' ]]; then
	if [ -z "$TMUX" ]; then
		printf '\e]50;CursorShape=1\x7'
	else
		printf '\ePtmux;\e\e]50;CursorShape=1\x7\e\\'
	fi
fi
if [[ `uname` == 'Linux' ]]; then
	if [ -z "$TMUX" ]; then
		printf '\e[6 q'
	else
		printf '\ePtmux;\e\e[6 q\e\\'
	fi
fi
