# load antigen
source ~/.scripts/zsh/antigen.zsh

# load zsh-autosuggestions
antigen bundle zsh-users/zsh-autosuggestions

# load better vim-mode
antigen bundle jeffreytse/zsh-vi-mode

# load zsh-syntax-highlighting
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply

if [ `command -v fastfetch` ]; then
  fastfetch
fi

# global user exports go up top so subscripts have access
source $HOME/.scripts/zsh/local.zsh
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=`which nvim`
export SUDO_EDITOR=`which nvim`
ulimit -n 2048
alias grep="grep --color=auto"
alias sudo="sudo "

# load starship prompt
if [ `command  -v starship` ]; then
  eval "$(starship init zsh)"
else
  echo "starship is not installed or available in path."
fi

if [ `command -v atuin` ]; then
  eval "$(atuin init zsh)"
fi

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# global user shortcuts
alias rsync='rsync --human-readable --progress -t'
alias svndiff='svn diff --diff-cmd diff -x "--unified=8 -p"'
alias copy='rsync --progress'
alias copydir='rsync --progress -av'

if [ `command -v batcat` ]; then
  function cat() {
    batcat $@
  }
fi
if [ `command -v bat` ]; then
  function cat() {
    bat $@
  }
fi
if [ `command -v nvimpager` ]; then
  export MANPAGER="nvimpager"
  export PAGER="nvimpager"
else
  export MANPAGER="less"
  export PAGER="less"
fi

ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE

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

export PATH="$PATH:$HOME/.local/bin"

# carapace setup
if [ `command -v carapace` ]; then
  export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
  zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
  source <(carapace _carapace)
else
  echo "carapace is not installed or available in path."
fi
