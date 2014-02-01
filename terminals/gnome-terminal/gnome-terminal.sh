#!/bin/bash 

# Save this script into set_colors.sh, make this file executable and run it: 
# 
# $ chmod +x set_colors.sh 
# $ ./set_colors.sh 
# 
# Alternatively copy lines below directly into your shell. 

gconftool-2 --set /apps/gnome-terminal/profiles/Default/use_theme_background --type bool false 
gconftool-2 --set /apps/gnome-terminal/profiles/Default/use_theme_colors --type bool false 
gconftool-2 -s -t string /apps/gnome-terminal/profiles/Default/background_color '#090908081212'
gconftool-2 -s -t string /apps/gnome-terminal/profiles/Default/foreground_color '#b5b5cdcdfafa'
gconftool-2 -s -t string /apps/gnome-terminal/profiles/Default/palette '#121212121212:#cdcd4a4a6060:#6060cdcd4a4a:#cdcdb7b74a4a:#4a4a6060cdcd:#b7b74a4acdcd:#4a4acdcdb7b7:#bcbcbcbcbcbc:#4a4a4a4a4a4a:#dada78788989:#8989dada7878:#dadacaca7878:#78788989dada:#caca7878dada:#7878dadacaca:#efefefefefef'
