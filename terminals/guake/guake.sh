#!/bin/bash 

# Save this script into set_colors.sh, make this file executable and run it: 
# 
# $ chmod +x set_colors.sh 
# $ ./set_colors.sh 
# 
# Alternatively copy lines below directly into your shell. 

gconftool-2 -s -t string /apps/guake/style/background/color '#090908081212'
gconftool-2 -s -t string /apps/guake/style/font/color '#b5b5cdcdfafa'
gconftool-2 -s -t string /apps/guake/style/font/palette '#121212121212:#4a4a4a4a4a4a:#cdcd4a4a6060:#dada78788989:#6060cdcd4a4a:#8989dada7878:#cdcdb7b74a4a:#dadacaca7878:#4a4a6060cdcd:#78788989dada:#b7b74a4acdcd:#caca7878dada:#4a4acdcdb7b7:#7878dadacaca:#bcbcbcbcbcbc:#efefefefefef'
