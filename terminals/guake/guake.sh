#!/bin/bash 

# Save this script into set_colors.sh, make this file executable and run it: 
# 
# $ chmod +x set_colors.sh 
# $ ./set_colors.sh 
# 
# Alternatively copy lines below directly into your shell. 

gconftool-2 -s -t string /apps/guake/style/background/color '#121214141616'
gconftool-2 -s -t string /apps/guake/style/font/color '#0b0b9595ffff'
gconftool-2 -s -t string /apps/guake/style/font/palette '#000000000000:#1c1c1c1c1c1c:#b2b227273737:#b2b227273737:#2f2fb5b52c2c:#2f2fb5b52c2c:#b2b2a8a82c2c:#b2b2a8a82c2c:#23233232baba:#23233232baba:#a5a52727baba:#a5a52727baba:#2323b5b5adad:#2323b5b5adad:#e6e6e6e6e6e6:#e6e6e6e6e6e6'
