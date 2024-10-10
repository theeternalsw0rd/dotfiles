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
echo "${txtwht}Installing git-credential-with-kwallet"
TARGET="$HOME/.local/bin/git-credential-with-kwallet"
if [ -e "$TARGET" ]; then
  if [ -L "$TARGET" ]; then
    SYMLINK=`readlink "$TARGET"`
    unlink "$TARGET"
    echo "${txtylw}Removed link from $TARGET to $SYMLINK${txtrst}"
  else
    mv "$TARGET" "$TARGET.$TIMESTAMP.bak${txtrst}"
    echo "${txtylw}Existing $TARGET moved to $TARGET.$TIMESTAMP.bak${txtrst}"
  fi
fi
ln -f -s "$BASEDIR/git-credential-with-kwallet/git-credential-with-kwallet" "$TARGET"
git config --global credential.helper with-kwallet
echo "${txtgrn}git-credential-with-kwallet installed to $TARGET and activated"
