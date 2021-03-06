#!/usr/bin/env bash
if [ "x$XDG_CONFIG_HOME" = "x" ]; then
	XDG_CONFIG_HOME="$HOME/.config"
fi
OS=`uname`
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

mkdir -p "$XDG_CONFIG_HOME"
echo
if [ `command -v git` ]; then
	echo "${txtwht}Installing git global ignore"
	if [ -e "$HOME/.gitignore_global" ]; then
		if [ -L "$HOME/.gitignore_global" ]; then
			SYMLINK=`readlink "$HOME/.gitignore_global"`
			unlink "$HOME/.gitignore_global"
			echo "${txtylw}Removed link from $HOME/.gitignore_global to $SYMLINK${txtrst}"
		else
			mv "$HOME/.gitignore_global" "$HOME/.gitignore_global.$TIMESTAMP.bak${txtrst}"
			echo "${txtylw}Existing $HOME/.gitignore_global moved to $HOME/.gitignore_global.$TIMESTAMP.bak${txtrst}"
		fi
	fi
	ln -f -s "$BASEDIR/gitignore_global.conf" "$HOME/.gitignore_global"
	git config --global core.excludesfile "$HOME/.gitignore_global"
	echo "${txtgrn}global gitignore installed to ~/.gitignore_global and activated"
fi
echo
if [ ! -e "$HOME/.scripts" ]; then
	mkdir -p "$HOME/.scripts"
	echo
	echo "${txtgrn} ~/.scripts staged${txtrst}"
fi
echo
echo "${txtwht}Installing vimpager scripts"
if [ -e "$HOME/.scripts/vimpager" ]; then
	if [ -L "$HOME/.scripts/vimpager" ]; then
		SYMLINK=`readlink "$HOME/.scripts/vimpager"`
		unlink "$HOME/.scripts/vimpager"
		echo "${txtylw}Removed link from ~/.scripts/vimpager to $SYMLINK${txtrst}"
	else
		mv "$HOME/.scripts/vimpager" "$HOME/.scripts/vimpager.$TIMESTAMP.bak${txtrst}"
		echo "${txtylw}Existing ~/.scripts/vimpager moved to ~/.scripts/vimpager.$TIMESTAMP.bak${txtrst}"
	fi
fi
ln -f -s "$BASEDIR/scripts/vimpager" "$HOME/.scripts/vimpager"
echo "${txtgrn}vimpager scripts installed"
echo
echo "${txtwht}Installing generic helper scripts"
if [ -e "$HOME/.scripts/helper" ]; then
	if [ -L "$HOME/.scripts/helper" ]; then
		SYMLINK=`readlink "$HOME/.scripts/helper"`
		unlink "$HOME/.scripts/helper"
		echo "${txtylw}Removed link from ~/.scripts/helper to $SYMLINK${txtrst}"
	else
		mv "$HOME/.scripts/helper" "$HOME/.scripts/helper.$TIMESTAMP.bak${txtrst}"
		echo "${txtylw}Existing ~/.scripts/helper moved to ~/.scripts/helper.$TIMESTAMP.bak${txtrst}"
	fi
fi
ln -f -s "$BASEDIR/scripts/helper" "$HOME/.scripts/helper"
echo "${txtgrn}helper scripts installed"
echo
if [ "`pidof transmission-daemon | sed 's/[0-9]*/1/'`" = "1" ]; then
	echo "${txtred}transmission-daemon is currently running, skipping configuration"
else
	echo "${txtwht}Installing transmission-daemon configuration files${txtrst}"
	if [ `command -v transmission-daemon` ]; then
		mkdir -p $XDG_CONFIG_HOME/transmission-daemon
		FILE="transmission-daemon/settings.json"
		if [ -e "$XDG_CONFIG_HOME/$FILE" ]; then
			if [ -L "$XDG_CONFIG_HOME/$FILE" ]; then
				SYMLINK=`readlink "$XDG_CONFIG_HOME/$FILE"`
				unlink "$XDG_CONFIG_HOME/$FILE"
				echo "${txtylw}Removed link from $XDG_CONFIG_HOME/$FILE to $SYMLINK${txtrst}"
			else
				mv "$XDG_CONFIG_HOME/$FILE" "$XDG_CONFIG_HOME/$FILE.$TIMESTAMP.bak"
				echo "${txtylw}Existing $XDG_CONFIG_HOME/$FILE moved to $XDG_CONFIG_HOME/$FILE.$TIMESTAMP.bak${txtrst}"
			fi
		fi
		cp "$BASEDIR/$FILE" "$XDG_CONFIG_HOME/$FILE"
		echo "${txtgrn}$FILE installed${txtrst}"
	else
		echo "${txtred}transmission-cli not installed or not in path so skipping related configuration files.${txtrst}"
	fi
fi
echo
echo "${txtwht}Installing zsh configuration files${txtrst}"
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

	FILE=scripts/zsh
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
	echo "${txtgrn}zsh scripts installed${txtrst}"

	FILE=scripts/zsh/local.zsh
	if [ ! -e "$HOME/.$FILE" ]; then
		echo "# local zsh configuration" > $HOME/.$FILE
		echo "${txtgrn}local zsh configuration ~/.$FILE created${txtrst}"
	else
		echo "${txtylw}leaving ~/.$FILE intact${txtrst}"
	fi

	FILE=scripts/zsh/path.zsh
	if [ ! -e "$HOME/.$FILE" ]; then
		echo "# zsh path override configuration" > $HOME/.$FILE
		echo "${txtgrn}zsh path override configuration ~/.$FILE created${txtrst}"
	else
		echo "${txtylw}leaving ~/.$FILE intact${txtrst}"
	fi
else
	echo "${txtred}zsh not installed or not in path so skipping related configuration files.${txtrst}"
fi

echo
echo "${txtwht}Installing vim configuration files${txtrst}"
if [ `command -v vim` ]; then
	mkdir -p "$HOME/.vim/tmp"
	echo "${txtylw}Created ~/.vim/tmp to store vim temporary session files.${txtrst}"
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

echo
echo "${txtwht}Installing tmux configuration files${txtrst}"
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

	FILE=scripts/tmux/local.conf
	if [ ! -e "$HOME/.$FILE" ]; then
		echo "# local tmux configuration" > $HOME/.$FILE
		echo "${txtgrn}local tmux configuration ~/.$FILE created${txtrst}"
	else
		echo "${txtylw}leaving ~/.$FILE intact${txtrst}"
	fi
	echo "${txtgrn}tmux scripts installed${txtrst}"
else
	echo "${txtred}tmux not installed or not in path so skipping related configuration files.${txtrst}"
fi

TEST=`ls -A "$HOME/.scripts" 2> /dev/null`
if [ "x$TEST" == "x" ]; then
	rm "$HOME/.scripts"
	echo
	echo "${txtgrn}~/.scripts was not needed and has been removed.${txtrst}"
fi
