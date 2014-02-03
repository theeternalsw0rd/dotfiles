#!/bin/bash
if [[ "$1" == "times" ]]; then
	uptime=`~/.scripts/helper/uptime.sh`
	date=`date +%Y-%m-%d`
	time=`date +%R`
	echo "$uptime  $date  $time"
fi
if [[ "$1" == "host" ]]; then
	ip=`dig +short myip.opendns.com @resolver1.opendns.com`
	hostname=`hostname`
	echo "`~/.scripts/helper/padder.sh $ip 15 ' '`  `~/.scripts/helper/padder.sh $hostname 8 ' '`"
fi
