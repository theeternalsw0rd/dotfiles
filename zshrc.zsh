# global user exports go up top so subscripts have access
source $HOME/.scripts/zsh/local.zsh
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=`which vim`
alias grep="grep --color=auto"
unset -v GREP_OPTIONS

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
	SESSION_TYPE=remote/ssh
	# many other tests omitted
else
	case $(ps -o comm= -p $PPID) in
		sshd|*/sshd) SESSION_TYPE=remote/ssh;;
	esac
fi
if [ "$SESSION_TYPE" = "remote/ssh" ] && [ -z "$TMUX" ]; then
	tmux -u a || tmux -u && exit
fi
# Path to your oh-my-zsh configuration.
ZSH=$HOME/.scripts/zsh/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="ys"

# Base16 Shell
BASE16_SHELL="$HOME/.scripts/zsh/base16.sh"
[[ -s $BASE16_SHELL ]] && . $BASE16_SHELL

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# Do this through git since we utilize our own repository
DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many days you would like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.scripts/zsh/oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.scripts/zsh/oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# global user shortcuts
alias edit='vim'
alias lsnew='ls -t | head -n 20'
alias lsdir='ls -F | grep '\/' | sed 's-/--g' | sort'
alias lsc='ls -1'
alias rsync='rsync --human-readable --progress -t'
alias svndiff='svn diff --diff-cmd diff -x "--unified=8 -p"'
alias copy='rsync --progress'
alias copydir='rsync --progress -av'
alias rping="$HOME/.scripts/helper/rping.zsh"
alias pager="$HOME/.scripts/vimpager/vimpager"

export MANPAGER="$HOME/.scripts/vimpager/vimpager"
export PAGER="$HOME/.scripts/vimpager/vimpager"

bindkey -v

bindkey -M viins '^[[Z' vi-cmd-mode
bindkey -a u undo
bindkey -a '^R' redo
bindkey '^?' backward-delete-char
bindkey '^H' backward-delete-char
bindkey '^f' history-incremental-search-backward
bindkey -M vicmd '?' vi-history-search-backward
bindkey -M vicmd '/' vi-history-search-forward

# xterm cursor - '\e[# q'
# 1 - blinking block
# 2 - solid block
# 3 - blinking underline
# 4 - solid underline
# 5 - blinking vertical bar
# 6 - solid vertical bar
#
# iTerm2 cursor - '\e]50;CursorShape=#\x7'
# 0 - solid block
# 1 - solid vertical bar
# 2 - solid underline
#
# tmux escape sequence (... is passed to terminal) - '\ePtmux;\e...\e\\'

function irc () {
	if [[ $TMUX = '' ]]; then
		weechat-curses
	else
		TERM=screen-256color weechat-curses
	fi
}

function codegrep () {
	if (( $# == 0 )); then # zero arguments
		echo "Usage:"
		echo "1: codegrep 'search term'"
		echo "2: codegrep ext 'search term'"
	fi
	if (( $# == 1 )); then # one argument
		find . -type f -exec grep -n "$1" /dev/null {} \;
	fi
	if (( $# == 2 )); then # two arguments
		find . -type f -name "*.$1" -exec grep -n "$2" /dev/null {} \;
	fi
}

#precmd() {
#	~/.scripts/helper/cursor_insert.zsh
#}

# just echo instead of zle -N zle-line-init
#~/.scripts/helper/cursor_insert.zsh

