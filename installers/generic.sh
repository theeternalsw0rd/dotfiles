#!/bin/sh
cd ..
BASEDIR=`pwd`
TIMESTAMP=`date +%s`

echo "Entered $BASEDIR"

# colored text thanks to http://kedar.nitty-witty.com/blog/how-to-echo-colored-text-in-shell-script
txtred=`tput setaf 1` # Red
txtgrn=`tput setaf 2` # Green
txtylw=`tput setaf 3` # Yellow
txtwht=`tput setaf 7` # White
txtrst=`tput sgr0` # Text reset.

if [ ! -e "$HOME/.scripts" ]; then
	mkdir -p "$HOME/.scripts"
	echo "${txtgrn} ~/.scripts staged${txtrst}"
fi
echo "${txtwht}\nInstalling zsh configuration files${txtrst}"
if [ `command -v zsh` ]; then
	FILE=zshrc
	if [ -e "$HOME/.$FILE" ]; then
		if [ -L "$HOME/.$FILE" ]; then
			SYMLINK=`readlink "$HOME/.$FILE"`
			unlink "$HOME/.$FILE"
			echo "${txtylw}Removed link from ~/.$FILE to $SYMLINK${txtrst}"
		else
			mv "$HOME/.$FILE" "$HOME/.$FILE.$TIMESTAMP.bak"
			echo "${txtylw}Existing ~/.$FILE moved to ~/.$FILE.$TIMESTAMP.bak${txtrst}"
		fi
	fi
	ln -f -s "$BASEDIR/$FILE.zsh" "$HOME/.$FILE"
	echo "${txtgrn}.$FILE installed${txtrst}"

	FILE=oh-my-zsh
	if [ -e "$HOME/.$FILE" ]; then
		if [ -L "$HOME/.$FILE" ]; then
			SYMLINK=`readlink "$HOME/.$FILE"`
			unlink "$HOME/.$FILE"
			echo "${txtylw}Removed link from ~/.$FILE to $SYMLINK${txtrst}"
		else
			mv "$HOME/.$FILE" "$HOME/.$FILE.$TIMESTAMP.bak"
			echo "${txtylw}Existing ~/.$FILE moved to ~/.$FILE.$TIMESTAMP.bak${txtrst}"
		fi
	fi
	ln -f -s "$BASEDIR/$FILE" "$HOME/.$FILE"
	echo "${txtgrn}.$FILE installed${txtrst}"

	FILE=.local.zsh
	if [ ! -e "$HOME/$FILE" ]; then
		echo "# local zsh configuration" > $HOME/$FILE
		echo "${txtgrn}local zsh configuration ~/$FILE created${txtrst}"
	else
		echo "${txtylw}leaving ~/$FILE intact${txtrst}"
	fi
else
	echo "${txtred}zsh not installed or not in path so skipping related configuration files.${txtrst}"
fi

echo "${txtwht}\nInstalling vim configuration files${txtrst}"
if [ `command -v vim` ]; then
	FILE=vimrc
	if [ -e "$HOME/.$FILE" ]; then
		if [ -L "$HOME/.$FILE" ]; then
			SYMLINK=`readlink "$HOME/.$FILE"`
			unlink "$HOME/.$FILE"
			echo "${txtylw}Removed link from ~/.$FILE to $SYMLINK${txtrst}"
		else
			mv "$HOME/.$FILE" "$HOME/.$FILE.$TIMESTAMP.bak"
			echo "${txtylw}Existing ~/.$FILE moved to ~/.$FILE.$TIMESTAMP.bak${txtrst}"
		fi
	fi
	ln -f -s "$BASEDIR/$FILE.vim" "$HOME/.$FILE"
	echo "${txtgrn}.$FILE installed${txtrst}"

	FILE=vim
	if [ -e "$HOME/.$FILE" ]; then
		if [ -L "$HOME/.$FILE" ]; then
			SYMLINK=`readlink "$HOME/.$FILE"`
			unlink "$HOME/.$FILE"
			echo "${txtylw}Removed link from ~/.$FILE to $SYMLINK${txtrst}"
		else
			mv "$HOME/.$FILE" "$HOME/.$FILE.$TIMESTAMP.bak"
			echo "${txtylw}Existing ~/.$FILE moved to ~/.$FILE.$TIMESTAMP.bak${txtrst}"
		fi
	fi
	ln -f -s "$BASEDIR/$FILE" "$HOME/.$FILE"
	echo "${txtgrn}.$FILE installed${txtrst}"

	if [ ! -e "$HOME/.cache/vim/undo" ]; then
		mkdir -p $HOME/.cache/vim/undo
		echo "${txtgrn}Created ~/.cache/vim/undo for sane persistent undo${txtrst}"
	fi
else
	echo "${txtred}vim not installed or not in path so skipping related configuration files.${txtrst}"
fi

echo "${txtwht}\nInstalling tmux configuration files${txtrst}"
if [ `command -v tmux` ]; then
	FILE=tmux.conf
	if [ -e "$HOME/.$FILE" ]; then
		if [ -L "$HOME/.$FILE" ]; then
			SYMLINK=`readlink "$HOME/.$FILE"`
			unlink "$HOME/.$FILE"
			echo "${txtylw}Removed link from ~/.$FILE to $SYMLINK${txtrst}"
		else
			mv "$HOME/.$FILE" "$HOME/.$FILE.$TIMESTAMP.bak"
			echo "${txtylw}Existing ~/.$FILE moved to ~/.$FILE.$TIMESTAMP.bak${txtrst}"
		fi
	fi
	ln -f -s "$BASEDIR/$FILE" "$HOME/.$FILE"
	echo "${txtgrn}.$FILE installed${txtrst}"

	FILE=scripts/tmux
	if [ -e "$HOME/.$FILE" ]; then
		if [ -L "$HOME/.$FILE" ]; then
			SYMLINK=`readlink "$HOME/.$FILE"`
			unlink "$HOME/.$FILE"
			echo "${txtylw}Removed link from ~/.$FILE to $SYMLINK${txtrst}"
		else
			mv "$HOME/.$FILE" "$HOME/.$FILE.$TIMESTAMP.bak"
			echo "${txtylw}Existing ~/.$FILE moved to ~/.$FILE.$TIMESTAMP.bak${txtrst}"
		fi
	fi
	ln -f -s "$BASEDIR/$FILE" "$HOME/.$FILE"
	echo "${txtgrn}.$FILE installed${txtrst}"
else
	echo "${txtred}tmux not installed or not in path so skipping related configuration files.${txtrst}"
fi

if [ x`ls -A "$HOME/.scripts" 2> /dev/null` == "x" ]; then
	rm "$HOME/.scripts"
	echo "${txtgrn}~/.scripts was not needed and has been removed.${txtrst}"
fi
