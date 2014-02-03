#!/bin/bash
if [[ "$1" == "times" ]]; then
	uptime=`~/.scripts/helper/uptime.sh`
	date=`date +%Y-%m-%d`
	time=`date +%R`
	echo "$uptime  $date  $time"
fi
if [[ "$1" == "host" ]]; then
	ip=`dig +short myip.opendns.com @resolver1.opendns.com | sed -e :a -e 's/^.\{1,15\}$/ & /;ta'`
	hostname=`hostname | sed -e :a -e 's/^.\{1,8\}$/ &/;ta'`
	echo "$ip  $hostname"
fi
