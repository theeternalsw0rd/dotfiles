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
export EDITOR=/usr/bin/vim

# global user shortcuts
alias irc='weechat-curses'
alias e='vim'
alias lsnew='ls -t | head -n 20'
alias lsdir='ls -F | grep '\/' | sed 's-/--g' | sort'
alias lsc='ls -1'
alias rsync='rsync --human-readable --progress -t'
alias svndiff='svn diff --diff-cmd diff -x "--unified=8 -p"'
alias copy='rsync --progress'
alias copydir='rsync --progress -av'

rping() {
	tmp=$1
	start=()
	start[1]=`echo $tmp | cut -d'.' -f1`
	start[2]=`echo $tmp | cut -d'.' -f2`
	start[3]=`echo $tmp | cut -d'.' -f3`
	start[4]=`echo $tmp | cut -d'.' -f4`
	tmp=$2
	stop[1]=`echo $tmp | cut -d'.' -f1`
	stop[2]=`echo $tmp | cut -d'.' -f2`
	stop[3]=`echo $tmp | cut -d'.' -f3`
	stop[4]=`echo $tmp | cut -d'.' -f4`

	while [[ ${start[4]} -le ${stop[4]} && ${start[2]} -le ${stop[2]} && ${start[3]} -le ${stop[3]} && ${start[1]} -le ${stop[1]} ]];
	do
		ip="${start[1]}.${start[2]}.${start[3]}.${start[4]}"
		ping -c1 -t1 $ip 2>&1 > /dev/null
		if [ "$?" -eq "0" ]; then
			echo $ip
		fi
		start[4]=$(( ${start[4]} + 1 ))
		if [ ${start[4]} -eq 255 ]; then
			start[4]=1
			start[3]=$(( ${start[3]} + 1 ))
			if [ ${start[3]} -eq 255 ]; then
				start[3]=1
				start[2]=$(( ${start[2]} + 1 ))
				if [ ${start[2]} -eq 255 ]; then
					start[2]=1
					start[1]=$(( ${start[1]} + 1 ))
					if [ ${start[1]} -eq 255 ]; then
						exit;
					fi
				fi
			fi
		fi
	done
}

source ~/.scripts/zsh/local.zsh
