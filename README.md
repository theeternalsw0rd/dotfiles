dotfiles
========

dot file configurations

Do a recursive checkout `git clone --recurse git://github.com/eternalsword/dotfiles.git`

Or if you already have cloned it and the subdirectories are empty, run `git submodule update --init` then `cd .vim` then `git submodule update --init`

Keep in mind the limitations of submodules.  If you want to update any of the submodules, create a branch and make your changes there or at least `git checkout master` first.

Master branch contains general configurations.

Other branches can be used for tracking machine specific configuration changes.

This repository contains some submodules: oh-my-zsh (.oh-my-zsh), vim-pathogen (.vim), vim-sensible (.vim/bundle/vim-sensible), vim-scriptease (.vim/bundle/vim-scriptease).

If you find my submodules to be out of date, you can add the upstream versions instead using `git add remote upstream URI` and then `git pull upstream master` inside the submodule directory. 

The vim subodules upstream are all at https://github.com/tpope and the oh-my-zsh can be found at https://github.com/robbyrussell/oh-my-zsh.

What I do is symlink the files in the repository to their respective spots in the home folder so as to aviod running a git repo right in my home folder.
I am including a script that will install everything where it should go.  It can be found at installers/generic.sh and should be run from inside the installers directory as `./generic.sh`.

I am also including the font I use in my terminals DejaVuSansMono (Menlo works fine too). I've included the ttf and its license in the font directory.

With regards to terminals, on OSX, I highly recommend iTerm2. On linux I started out using tilda, then switched to guake then to rxvt-unicode (urxvt) then xterm and finally settled on Konsole. I don't particularly like having to install KDE just to use Konsole, but Konsole acts the most like iTerm2 on OSX allowing for easier cross-platform configuration and is the only linux terminal I could get to properly run the full unicode set.

I will put linux-specific items in the linux subdirectory and osx-specific items in the osx subdirectory, each with their own sub-installers.
