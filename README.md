dotfiles
========

dot file configurations

Master branch contains general configurations.

Other branches can be used for tracking machine specific configuration changes.

This repository contains some submodules: oh-my-zsh (.oh-my-zsh), vim-pathogen (.vim/autoload), vim-sensible (.vim/bundle/vim-sensible), vim-scriptease (.vim/bundle/vim-scriptease).
If you find my submodules to be out of date, you can add the upstream versions instead using `git add remote upstream URI` and then `git pull upstream master` inside the submodule directory. 
The vim subodules upstream are all at https://github.com/tpope and the oh-my-zsh can be find out https://github.com/robbyrussell/oh-my-zsh.

What I do is symlink the files in the repository to their respective spots in the home folder so as to aviod running a git repo right in my home folder.
I am including a script that will install everything where it should go.

I am also including the font I use in my terminals DejaVuSansMono. I've included the ttf and its license in the font directory.

With regards to terminals, on OSX, I highly recommend iTerm2. On linux I started out using tilda, then switched to guake and finally settled on rxvt-unicode (urxvt).

I will put linux-specific items in the linux subdirectory and osx-specific items in the osx subdirectory, each with their own sub-installers.
