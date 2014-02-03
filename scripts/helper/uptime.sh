#!/bin/bash
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
	daystring=$days"d"
	hours=$((($seconds/60/60)%24))
	hourstring="`~/.scripts/helper/padder.sh $hours 2 0`h"
	minutes=$((($seconds/60)%60))
	minutestring="`~/.scripts/helper/padder.sh $minutes 2 0`m"
	echo "$daystring $hourstring $minutestring"
fi
