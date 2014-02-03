#!/bin/bash
word="$1"
while [ ${#word} -lt $2 ]; do
	if [[ "$4" == "right" ]]; then
		word="$word$3";
	else
		word="$3$word";
	fi
done;
echo "$word";
