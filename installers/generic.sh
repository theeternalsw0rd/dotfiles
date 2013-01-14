#!/bin/sh
cd ..
BASEDIR=`pwd`
TIMESTAMP=`date +%s`

echo "Entered $BASEDIR"

FILE=.zshrc
if [ -e "$HOME/$FILE" ]; then
	if [ -L "$HOME/$FILE" ]; then
		SYMLINK=`readlink "$HOME/$FILE"`
		unlink "$HOME/$FILE"
		echo "Removed link from ~/$FILE to $SYMLINK"
	else
		mv "$HOME/$FILE" "$HOME/$FILE.$TIMESTAMP.bak"
		echo "Existing ~/$FILE moved to ~/$FILE.$TIMESTAMP.bak"
	fi
fi
ln -f -s "$BASEDIR/$FILE" "$HOME/$FILE"
echo "$FILE installed"

FILE=.vimrc
if [ -e "$HOME/$FILE" ]; then
	if [ -L "$HOME/$FILE" ]; then
		SYMLINK=`readlink "$HOME/$FILE"`
		unlink "$HOME/$FILE"
		echo "Removed link from ~/$FILE to $SYMLINK"
	else
		mv "$HOME/$FILE" "$HOME/$FILE.$TIMESTAMP.bak"
		echo "Existing ~/$FILE moved to ~/$FILE.$TIMESTAMP.bak"
	fi
fi
ln -f -s "$BASEDIR/$FILE" "$HOME/$FILE"
echo "$FILE installed"

FILE=.vim
if [ -e "$HOME/$FILE" ]; then
	if [ -L "$HOME/$FILE" ]; then
		SYMLINK=`readlink "$HOME/$FILE"`
		unlink "$HOME/$FILE"
		echo "Removed link from ~/$FILE to $SYMLINK"
	else
		mv "$HOME/$FILE" "$HOME/$FILE.$TIMESTAMP.bak"
		echo "Existing ~/$FILE moved to ~/$FILE.$TIMESTAMP.bak"
	fi
fi
ln -f -s "$BASEDIR/$FILE" "$HOME/$FILE"
echo "$FILE installed"

FILE=.tmux.conf
if [ -e "$HOME/$FILE" ]; then
	if [ -L "$HOME/$FILE" ]; then
		SYMLINK=`readlink "$HOME/$FILE"`
		unlink "$HOME/$FILE"
		echo "Removed link from ~/$FILE to $SYMLINK"
	else
		mv "$HOME/$FILE" "$HOME/$FILE.$TIMESTAMP.bak"
		echo "Existing ~/$FILE moved to ~/$FILE.$TIMESTAMP.bak"
	fi
fi
ln -f -s "$BASEDIR/$FILE" "$HOME/$FILE"
echo "$FILE installed"

FILE=.oh-my-zsh
if [ -e "$HOME/$FILE" ]; then
	if [ -L "$HOME/$FILE" ]; then
		SYMLINK=`readlink "$HOME/$FILE"`
		unlink "$HOME/$FILE"
		echo "Removed link from ~/$FILE to $SYMLINK"
	else
		mv "$HOME/$FILE" "$HOME/$FILE.$TIMESTAMP.bak"
		echo "Existing ~/$FILE moved to ~/$FILE.$TIMESTAMP.bak"
	fi
fi
ln -f -s "$BASEDIR/$FILE" "$HOME/$FILE"
echo "$FILE installed"

FILE=.local.zsh
if [ ! -e "$HOME/$FILE" ]; then
	echo "# local zsh configuration" > $HOME/$FILE
	echo "local zsh configuration ~/$FILE created"
else
	echo "leaving ~/$FILE intact"
fi

mkdir -p $HOME/.cache/vim/undo
echo "Created $HOME/.cache/vim/undo for sane persistent undo"

