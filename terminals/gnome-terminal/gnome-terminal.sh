#!/bin/bash 

# Save this script into set_colors.sh, make this file executable and run it: 
# 
# $ chmod +x set_colors.sh 
# $ ./set_colors.sh 
# 
# Alternatively copy lines below directly into your shell. 

gconftool-2 --set /apps/gnome-terminal/profiles/Default/use_theme_background --type bool false 
gconftool-2 --set /apps/gnome-terminal/profiles/Default/use_theme_colors --type bool false 
gconftool-2 -s -t string /apps/gnome-terminal/profiles/Default/background_color '#121214141616'
gconftool-2 -s -t string /apps/gnome-terminal/profiles/Default/foreground_color '#0b0b9595ffff'
gconftool-2 -s -t string /apps/gnome-terminal/profiles/Default/palette '#000000000000:#b2b227273737:#2f2fb5b52c2c:#b2b2a8a82c2c:#23233232baba:#a5a52727baba:#2323b5b5adad:#e6e6e6e6e6e6:#1c1c1c1c1c1c:#b2b227273737:#2f2fb5b52c2c:#b2b2a8a82c2c:#23233232baba:#a5a52727baba:#2323b5b5adad:#e6e6e6e6e6e6'
