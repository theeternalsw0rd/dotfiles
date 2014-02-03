#!/bin/bash
function lpad {
	word="$1"
	while [ ${#word} -lt $2 ]; do
		if [[ "$4" == "right" ]]; then
			word="$word$3";
		else
			word="$3$word";
		fi
	done;
	echo "$word";
}
if [[ "$1" == "times" ]]; then
	uptime=`~/.scripts/helper/uptime.sh`
	date=`date +%Y-%m-%d`
	time=`date +%R`
	echo "$uptime  $date  $time"
fi
if [[ "$1" == "host" ]]; then
	ip=`dig +short myip.opendns.com @resolver1.opendns.com`
	hostname=`hostname`
	echo "`lpad $ip 15 ' '`  `lpad $hostname 8 ' '`"
fi
