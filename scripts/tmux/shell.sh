#!/bin/sh

if [ "`uname`" = "Darwin" ]; then
	if [ ! -z `which reattach-to-user-namespace` ]; then
		reattach-to-user-namespace -l $SHELL
	else
		$SHELL
	fi
else
	$SHELL
fi
