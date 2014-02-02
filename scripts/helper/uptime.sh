#!/bin/sh
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
	platform='linux'
	seconds=`cat /proc/uptime | sed 's/\([0-9]*\).*/\1/'`
elif [[ "$unamestr" == 'Darwin' ]]; then
	platform='darwin'
	seconds=$((`awk 'BEGIN{srand();print srand()}'`-`sysctl -n kern.boottime | sed 's/[^0-9]*\([0-9]*\).*/\1/'`))
fi
if [[ "$platform" != 'unknown' ]]; then
	days=$(($seconds/60/60/24))
	daystring=""
	if [[ $days > 0 ]]; then
		daystring=$days"d "
	fi
	hours=$((($seconds/60/60)%24))
	hourstring=""
	if [[ $hours > 0 || $days > 0 ]]; then
		if [[ $hours < 10 ]]; then
			hourstring="0"$hours"h "
		else
			hourstring=$hours"h "
		fi
	fi
	minutes=$((($seconds/60)%60))
	if [[ $minutes < 10 ]]; then
		minutestring="0"$minutes"m"
	else
		minutestring=$minutes"m"
	fi
	echo $daystring$hourstring$minutestring
fi
