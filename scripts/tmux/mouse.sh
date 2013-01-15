#!/bin/sh
STATE=`tmux show-window-options -g | grep mode-mouse | grep -cw on`
if [ x$STATE == "x1" ]; then
	tmux setw -g mode-mouse off > /dev/null &
	tmux setw -g mouse-select-pane off > /dev/null &
	tmux setw -g mouse-select-window off > /dev/null &
	tmux setw -g mouse-resize-pane off > /dev/null &
	tmux display-message "Mouse OFF"
else
	tmux setw -g mode-mouse on > /dev/null &
	tmux setw -g mouse-select-pane on > /dev/null &
	tmux setw -g mouse-select-window on > /dev/null &
	tmux setw -g mouse-resize-pane on > /dev/null &
	tmux display-message "Mouse ON"
fi
