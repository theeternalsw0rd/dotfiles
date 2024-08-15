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

# load antigen
source ~/.scripts/zsh/antigen.zsh

# load zsh-autosuggestions
antigen bundle zsh-users/zsh-autosuggestions

# load better vim-mode
antigen bundle jeffreytse/zsh-vi-mode

# load zsh-syntax-highlighting
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# global user exports go up top so subscripts have access
source $HOME/.scripts/zsh/local.zsh
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=`which nvim`
ulimit -n 2048
alias grep="grep --color=auto"

# load powerlevel10k
source ~/.scripts/zsh/powerlevel10k/powerlevel10k.zsh-theme

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# global user shortcuts
alias rsync='rsync --human-readable --progress -t'
alias svndiff='svn diff --diff-cmd diff -x "--unified=8 -p"'
alias copy='rsync --progress'
alias copydir='rsync --progress -av'
alias rping="$HOME/.scripts/helper/rping.zsh"


if [ `command -v batcat` ]; then
  export MANPAGER="batcat"
  export PAGER="batcat"
elif [ `command -v bat` ]; then
  export MANPAGER="bat"
  export PAGER="bat"
else
  export MANPAGER="less"
  export PAGER="less"
fi

ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_UNDERLINE

#bindkey -v

#bindkey -M viins '^[[Z' vi-cmd-mode
#bindkey -a u undo
#bindkey -a '^R' redo
#bindkey '^?' backward-delete-char
#bindkey '^H' backward-delete-char
#bindkey '^f' history-incremental-search-backward
#bindkey -M vicmd '?' vi-history-search-backward
#bindkey -M vicmd '/' vi-history-search-forward

#bindkey '^[[A' history-search-backward
#bindkey '^[[B' history-search-forward

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

function telnet() {
	echoti rmkx
	command telnet $@
}

function mkpasswd() {
	base64 /dev/urandom | tr -d '/+oO0l1I' | head -c $1
}

# zsh command history configuration
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# put at end to override any other scripts
unset -v GREP_OPTIONS
[[ -x /usr/libexec/path_helper ]] && export PATH='' && eval $(/usr/libexec/path_helper -s)
source $HOME/.scripts/zsh/path.zsh

# this is annoying but until universal support is available
if [ `command -v nvim` ]; then
  function vim() {
    nvim $@
  }
  function wezvim() {
    env TERM=wezterm nvim $@
  }
fi

if [ `command -v eza` ]; then
  function ls() {
    eza --icons $@
  }
fi

if [ `command -v zoxide` ]; then
  eval "$(zoxide init --no-cmd zsh)"
  function cd() {
    __zoxide_z $@
  }
fi

if [ `command -v eza` ]; then
  alias lsnew='eza --icons --sort=oldest -l --color=always | head -n 20'
  alias lsdir="eza --icons --color=always -F | grep '\/' | sed 's%/$%%g' | sort --ignore-case"
  alias lsc='eza --icons -1'
else
  alias lsnew='ls --sort=oldest -l --color=always | head -n 20'
  alias lsdir="ls --color=always -F | grep '\/' | sed 's%/$%%g' | sort --ignore-case"
  alias lsc='ls -1'
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
