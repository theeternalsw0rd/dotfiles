#!/usr/bin/env bash
if [ "x$XDG_CONFIG_HOME" = "x" ]; then
	XDG_CONFIG_HOME="$HOME/.config"
fi
if [ ! -e "$HOME/.config" ]; then
	mkdir "$HOME/.config"
	echo
	echo "${txtgrn} ~/.config staged${txtrst}"
fi

OS=`uname | awk '{ print tolower($1) }'`
cd ..
BASEDISTRO="darwin"
if [ `command -v pacman` ]; then
	BASEDISTRO="arch"
fi
if [ `command -v apt` ]; then
	BASEDISTRO="debian"
fi
DISTRO="macos"
BASEDIR=`pwd`
TIMESTAMP=`date +%s`

echo "Entered $BASEDIR"

# colored text thanks to http://kedar.nitty-witty.com/blog/how-to-echo-colored-text-in-shell-script
txtred=`tput setaf 1` # Red
txtgrn=`tput setaf 2` # Green
txtylw=`tput setaf 3` # Yellow
txtwht=`tput setaf 7` # White
txtrst=`tput sgr0` # Text reset.


# OS specific
# start macOS aka darwin
if [ "$OS" = "darwin" ]; then
  echo
  echo "${txtwht}Installing phoenix config"
	if [ -e "/Applications/Phoenix.app" ]; then
		if [ -e "$HOME/.config/phoenix" ]; then
			if [ -L "$HOME/.config/phoenix" ]; then
				SYMLINK=`readlink "$HOME/.config/phoenix"`
				unlink "$HOME/.config/phoenix"
				echo "${txtylw}Removed link from ~/.config/phoenix to $SYMLINK${txtrst}"
			else
				mv "$HOME/.config/phoenix" "$HOME/.config/phoenix.$TIMESTAMP.bak${txtrst}"
				echo "${txtylw}Existing ~/.config/phoenix moved to ~/.config/phoenix.$TIMESTAMP.bak${txtrst}"
			fi
		fi
		ln -f -s "$BASEDIR/phoenix" "$HOME/.config/phoenix"
		echo "${txtgrn}phoenix configuration installed"
	else
		echo
		echo "${txtred}Phoenix is not installed. Phoenix is needed for making wezterm quake-style on macOS."
	fi
fi
# end macOS ak darwin
# start linux
if [ "$OS" = "linux" ]; then
  DISTRO=`grep --no-filename /etc/*release -e "^ID=" | sed 's/ID=\(.*\)/\1/'`
fi
# end linux

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
	git config --global user.name "Micah Bucy"
	git config --global user.email "micah.bucy@theeternalsw0rd.rocks"
	git config --global init.defaultBranch main
fi
echo
if [ ! -e "$HOME/.scripts" ]; then
	mkdir -p "$HOME/.scripts"
	echo
	echo "${txtgrn} ~/.scripts staged${txtrst}"
fi
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
if [ `command -v tic` ]; then
	echo
	echo "${txtwht}Installing wezterm terminfo file"
	tempfile=$(mktemp) \
		&& curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo \
		&& tic -x -o ~/.terminfo $tempfile \
		&& rm $tempfile
	echo "${txtgrn}wezterm terminfo file installed"
  tic -x -o ~/.terminfo "$BASEDIR/wezterm-direct.terminfo"
  echo "${txtgrn}wezterm-direct terminfo file installed"
fi
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
echo "${txtwht}Installing wezterm configuration files${txtrst}"
if [ `command -v wezterm` ]; then
	if [ -e "$HOME/.config/wezterm" ]; then
		if [ -L "$HOME/.config/wezterm" ]; then
			SYMLINK=`readlink "$HOME/.config/wezterm"`
			unlink "$HOME/.config/wezterm"
			echo "${txtylw}Removed link from ~/.config/wezterm to $SYMLINK${txtrst}"
		else
			mv "$HOME/.config/wezterm" "$HOME/.config/wezterm.$TIMESTAMP.bak"
			echo "${txtylw}Existing ~/.config/wezterm moved to ~/.config/wezterm.bak${txtrst}"
		fi
	fi
	ln -f -s "$BASEDIR/wezterm-config" "$HOME/.config/wezterm"
	echo "${txtgrn}wezterm configuration installed${txtrst}"
	echo
else
	echo
	echo "${txtred}wezterm is not installed so skipping related configuration files"
fi
echo
echo "${txtwht}Installing kitty configuration files${txtrst}"
if [ `command -v kitty` ]; then
  TARGET=$HOME/.config/kitty
  mkdir -p $TARGET
	FILE=kitty.conf
	if [ -e "$TARGET/$FILE" ]; then
		if [ -L "$TARGET/$FILE" ]; then
			SYMLINK=`readlink "$TARGET/$FILE"`
			unlink "$TARGET/$FILE"
			echo "${txtylw}Removed link from ~/.config/kitty/$FILE to $SYMLINK${txtrst}"
		else
			mv "$TARGET/$FILE" "$TARGET/$FILE.$TIMESTAMP.bak"
			echo "${txtylw}Existing ~/.config/kitty/$FILE moved to ~/.config/kitty/$FILE.$TIMESTAMP.bak${txtrst}"
		fi
	fi
	ln -f -s "$BASEDIR/$FILE" "$TARGET/$FILE"
	echo "${txtgrn}$TARGET/$FILE installed${txtrst}"
	echo
fi
echo
echo "${txtwht}Installing starship configuration file${txtrst}"
if [ `command -v starship` ]; then
  TARGET=$HOME/.config
  mkdir -p $TARGET
	FILE=starship.toml
	if [ -e "$TARGET/$FILE" ]; then
		if [ -L "$TARGET/$FILE" ]; then
			SYMLINK=`readlink "$TARGET/$FILE"`
			unlink "$TARGET/$FILE"
			echo "${txtylw}Removed link from ~/.config/$FILE to $SYMLINK${txtrst}"
		else
			mv "$TARGET/$FILE" "$TARGET/$FILE.$TIMESTAMP.bak"
			echo "${txtylw}Existing ~/.config/$FILE moved to ~/.config/$FILE.$TIMESTAMP.bak${txtrst}"
		fi
	fi
	ln -f -s "$BASEDIR/$FILE" "$TARGET/$FILE"
	echo "${txtgrn}$TARGET/$FILE installed${txtrst}"
	echo
fi
echo
echo "${txtwht}Installing fish configuration file${txtrst}"
if [ `command -v fish` ]; then
  TARGET=$HOME/.config/fish
  mkdir -p $TARGET
	FILE=config.fish
	if [ -e "$TARGET/$FILE" ]; then
		if [ -L "$TARGET/$FILE" ]; then
			SYMLINK=`readlink "$TARGET/$FILE"`
			unlink "$TARGET/$FILE"
			echo "${txtylw}Removed link from ~/.config/fish/$FILE to $SYMLINK${txtrst}"
		else
			mv "$TARGET/$FILE" "$TARGET/$FILE.$TIMESTAMP.bak"
			echo "${txtylw}Existing ~/.config/fish/$FILE moved to ~/.config/fish/$FILE.$TIMESTAMP.bak${txtrst}"
		fi
	fi
	ln -f -s "$BASEDIR/$FILE" "$TARGET/$FILE"
	echo "${txtgrn}$TARGET/$FILE installed${txtrst}"
	echo
	TARGET=$HOME/.config/fish/conf.d/
	FILE="config.$BASEDISTRO.fish"
	if [ -e "$TARGET/$FILE" ]; then
		if [ -L "$TARGET/$FILE" ]; then
			SYMLINK=`readlink "$TARGET/$FILE"`
			unlink "$TARGET/$FILE"
			echo "${txtylw}Removed link from ~/.config/fish/conf.d/$FILE to $SYMLINK${txtrst}"
		else
			mv "$TARGET/$FILE" "$TARGET/$FILE.$TIMESTAMP.bak"
			echo "${txtylw}Existing ~/.config/fish/conf.d/$FILE moved to ~/.config/fish/conf.d/$FILE.$TIMESTAMP.bak${txtrst}"
		fi
	fi
	ln -f -s "$BASEDIR/fish/$FILE" "$TARGET/$FILE"
	echo "${txtgrn}$TARGET/$FILE installed${txtrst}"
	echo
else
  echo
  echo "${txtred} fish is not installed so skipping related configuration files."
fi
echo
echo
echo "${txtwht}Installing fastfetch configuration file${txtrst}"
if [ `command -v fastfetch` ]; then
  TARGET=$HOME/.config
  mkdir -p $TARGET
	FILE=fastfetch
	if [ -e "$TARGET/$FILE" ]; then
		if [ -L "$TARGET/$FILE" ]; then
			SYMLINK=`readlink "$TARGET/$FILE"`
			unlink "$TARGET/$FILE"
			echo "${txtylw}Removed link from ~/.config/$FILE to $SYMLINK${txtrst}"
		else
			mv "$TARGET/$FILE" "$TARGET/$FILE.$TIMESTAMP.bak"
			echo "${txtylw}Existing ~/.config/$FILE moved to ~/.config/$FILE.$TIMESTAMP.bak${txtrst}"
		fi
	fi
	ln -f -s "$BASEDIR/$FILE" "$TARGET/$FILE"
  cp "$BASEDIR/$FILE/pngs/$DISTRO-chan.png" "$BASEDIR/$FILE/pngs/os-chan.png"
	echo "${txtgrn}$TARGET/$FILE installed${txtrst}"
	echo
else
  echo
  echo "${txtred} fastfetch is not installed so skipping related configuration files."
fi
echo
echo "${txtwht}Installing nushell configuration file${txtrst}"
if [ `command -v nu` ]; then
  TARGET=$HOME/.config/nushell
  mkdir -p $TARGET
	FILE=config.nu
	if [ -e "$TARGET/$FILE" ]; then
		if [ -L "$TARGET/$FILE" ]; then
			SYMLINK=`readlink "$TARGET/$FILE"`
			unlink "$TARGET/$FILE"
			echo "${txtylw}Removed link from ~/.config/nushell/$FILE to $SYMLINK${txtrst}"
		else
			mv "$TARGET/$FILE" "$TARGET/$FILE.$TIMESTAMP.bak"
			echo "${txtylw}Existing ~/.config/nushell/$FILE moved to ~/.config/nushell/$FILE.$TIMESTAMP.bak${txtrst}"
		fi
	fi
	ln -f -s "$BASEDIR/$FILE" "$TARGET/$FILE"
	echo "${txtgrn}$TARGET/$FILE installed${txtrst}"
	echo
else
  echo
  echo "${txtred} nushell is not installed so skipping related configuration files."
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

	FILE=p10k.zsh
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
echo "${txtwht}Installing nvim configuration files${txtrst}"
if [ `command -v nvim` ]; then
	TARGET=".config"
	IPATH="$HOME/$TARGET"
	mkdir -p $IPATH
	FILE=nvim
	if [ -e "$IPATH/$FILE" ]; then
		if [ -L "$IPATH/$FILE" ]; then
			SYMLINK=`readlink "$IPATH/$FILE"`
			unlink "$IPATH/$FILE"
			echo "${txtylw}Removed link from ~/$TARGET to $SYMLINK${txtrst}"
		else
			mv "$IPATH" "$IPATH.$TIMESTAMP.bak"
			echo "${txtylw}Existing ~/$TARGET moved to ~/$TARGET.$TIMESTAMP.bak${txtrst}"
		fi
	fi
	ln -f -s "$BASEDIR/$FILE" "$IPATH"
	echo "${txtgrn}nvim configuration installed${txtrst}"
else
	echo "${txtred}nvim not installed or not in path so skipping related configuration files.${txtrst}"
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
