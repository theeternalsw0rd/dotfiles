#!/bin/sh
cd ..
BASEDIR=`pwd`
TIMESTAMP=`date +%s`

echo "Entered $BASEDIR"

if [ command -v zsh ]; then
	FILE=zshrc
	if [ -e "$HOME/.$FILE" ]; then
		if [ -L "$HOME/.$FILE" ]; then
			SYMLINK=`readlink "$HOME/.$FILE"`
			unlink "$HOME/.$FILE"
			echo "Removed link from ~/.$FILE to $SYMLINK"
		else
			mv "$HOME/.$FILE" "$HOME/.$FILE.$TIMESTAMP.bak"
			echo "Existing ~/.$FILE moved to ~/.$FILE.$TIMESTAMP.bak"
		fi
	fi
	ln -f -s "$BASEDIR/$FILE.zsh" "$HOME/.$FILE"
	echo ".$FILE installed"

	FILE=oh-my-zsh
	if [ -e "$HOME/.$FILE" ]; then
		if [ -L "$HOME/.$FILE" ]; then
			SYMLINK=`readlink "$HOME/.$FILE"`
			unlink "$HOME/.$FILE"
			echo "Removed link from ~/.$FILE to $SYMLINK"
		else
			mv "$HOME/.$FILE" "$HOME/.$FILE.$TIMESTAMP.bak"
			echo "Existing ~/.$FILE moved to ~/.$FILE.$TIMESTAMP.bak"
		fi
	fi
	ln -f -s "$BASEDIR/$FILE" "$HOME/.$FILE"
	echo ".$FILE installed"

	FILE=.local.zsh
	if [ ! -e "$HOME/$FILE" ]; then
		echo "# local zsh configuration" > $HOME/$FILE
		echo "local zsh configuration ~/$FILE created"
	else
		echo "leaving ~/$FILE intact"
	fi
else
	echo "zsh not installed skipping related configuration files."
fi

if [ command -v vim ]; then
	FILE=vimrc
	if [ -e "$HOME/.$FILE" ]; then
		if [ -L "$HOME/.$FILE" ]; then
			SYMLINK=`readlink "$HOME/.$FILE"`
			unlink "$HOME/.$FILE"
			echo "Removed link from ~/.$FILE to $SYMLINK"
		else
			mv "$HOME/.$FILE" "$HOME/.$FILE.$TIMESTAMP.bak"
			echo "Existing ~/.$FILE moved to ~/.$FILE.$TIMESTAMP.bak"
		fi
	fi
	ln -f -s "$BASEDIR/$FILE.vim" "$HOME/.$FILE"
	echo ".$FILE installed"

	FILE=vim
	if [ -e "$HOME/.$FILE" ]; then
		if [ -L "$HOME/.$FILE" ]; then
			SYMLINK=`readlink "$HOME/.$FILE"`
			unlink "$HOME/.$FILE"
			echo "Removed link from ~/.$FILE to $SYMLINK"
		else
			mv "$HOME/.$FILE" "$HOME/.$FILE.$TIMESTAMP.bak"
			echo "Existing ~/.$FILE moved to ~/.$FILE.$TIMESTAMP.bak"
		fi
	fi
	ln -f -s "$BASEDIR/$FILE" "$HOME/.$FILE"
	echo ".$FILE installed"

	mkdir -p $HOME/.cache/vim/undo
	echo "Created ~/.cache/vim/undo for sane persistent undo"
else
	echo "vim not installed or not in path so skipping related configuration files."
fi

if [ command -v tmux ]; then
	FILE=tmux.conf
	if [ -e "$HOME/.$FILE" ]; then
		if [ -L "$HOME/.$FILE" ]; then
			SYMLINK=`readlink "$HOME/.$FILE"`
			unlink "$HOME/.$FILE"
			echo "Removed link from ~/.$FILE to $SYMLINK"
		else
			mv "$HOME/.$FILE" "$HOME/.$FILE.$TIMESTAMP.bak"
			echo "Existing ~/.$FILE moved to ~/.$FILE.$TIMESTAMP.bak"
		fi
	fi
	ln -f -s "$BASEDIR/$FILE" "$HOME/.$FILE"
	echo ".$FILE installed"

	FILE=tmux.mouse.sh
	if [ -e "$HOME/.$FILE" ]; then
		if [ -L "$HOME/.$FILE" ]; then
			SYMLINK=`readlink "$HOME/.$FILE"`
			unlink "$HOME/.$FILE"
			echo "Removed link from ~/.$FILE to $SYMLINK"
		else
			mv "$HOME/.$FILE" "$HOME/.$FILE.$TIMESTAMP.bak"
			echo "Existing ~/.$FILE moved to ~/.$FILE.$TIMESTAMP.bak"
		fi
	fi
	ln -f -s "$BASEDIR/$FILE" "$HOME/.$FILE"
	echo ".$FILE installed"
else
	echo "tmux not installed or not in path so skipping related configuration files."
fi
