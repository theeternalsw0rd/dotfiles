#!/bin/bash
if [[ "$1" == "times" ]]; then
	uptime=`~/.scripts/helper/uptime.sh`
	date=`date +%Y-%m-%d`
	time=`date +%R`
	echo "$uptime  $date  $time"
fi
if [[ "$1" == "host" ]]; then
	if hash dig 2>/dev/null; then
		ip=`dig +short myip.opendns.com @resolver1.opendns.com`
	else
		ip="install dig"
	fi
	hostname=`hostname`
	echo "`~/.scripts/helper/padder.sh "$ip" 15 ' '`  `~/.scripts/helper/padder.sh $hostname 8 ' '`"
fi
