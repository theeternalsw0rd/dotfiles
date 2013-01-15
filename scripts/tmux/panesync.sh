#!/bin/sh
STATE=`tmux show-window-options | grep synchronize-panes | grep -cw on`
if [ x$STATE == "x1" ]; then
	MESSAGE=`tmux set-window-option synchronize-panes off`
else
	MESSAGE=`tmux set-window-option synchronize-panes on`
fi
tmux display-message "$MESSAGE"
