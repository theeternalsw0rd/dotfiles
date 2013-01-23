# Path to your oh-my-zsh configuration.
ZSH=$HOME/.scripts/zsh/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="frosted"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many days you would like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.scripts/zsh/oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.scripts/zsh/oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# global user exports
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=`which vim`

# global user shortcuts
alias edit='vim'
alias lsnew='ls -t | head -n 20'
alias lsdir='ls -F | grep '\/' | sed 's-/--g' | sort'
alias lsc='ls -1'
alias rsync='rsync --human-readable --progress -t'
alias svndiff='svn diff --diff-cmd diff -x "--unified=8 -p"'
alias copy='rsync --progress'
alias copydir='rsync --progress -av'
alias rping='~/.scripts/helper/rping.zsh'
alias cat='~/.scripts/vimpager/vimcat'
alias pager='~/.scripts/vimpager/vimpager'

export MANPAGER='~/.scripts/vimpager/vimpager'
export PAGER='~/.scripts/vimpager/vimpager'

bindkey -v

# \e[\x31 - blinking block
# \e[\x32 - solid block
# \e[\x33 - blinking underline
# \e[\x34 - solid underline
# \e[\x35 - blinking vertical bar (tmux > 1.6 ! urxvt)
# \e[\x36 - solid vertical bar (tmux > 1.6 ! urxvt)

function irc () {
	if [[ $TMUX = '' ]]; then
		weechat-curses
	else
		TERM=screen-256color weechat-curses
	fi
}

function zle-keymap-select {
	if [[ $KEYMAP = vicmd ]]; then
		echo -ne "\e[\x32 q"
	else
		echo -ne "\e[\x34 q"
	fi
	#zle reset-prompt
}

# just echo instead of zle -N zle-line-init
echo -ne "\e[\x34 q"
zle -N zle-keymap-select

source ~/.scripts/zsh/local.zsh
