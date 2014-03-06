dotfiles
========

dot file configurations

Do a recursive checkout `git clone --recurse git://github.com/eternalsword/dotfiles.git`

Or if you already have cloned it and the subdirectories are empty, run `git submodule update --init --recursive`

Keep in mind the limitations of submodules.  If you want to update any of the submodules, create a branch and make your changes there or at least `git checkout master` first.

This repository contains general configurations only. Local machine-specific configurations should be stored in the appropriate local files. Also put anything with usernames, ips, passwords, etc in there so as to avoid making it public.

This repository contains many submodules.

If you find my submodules to be out of date, you can add the upstream versions instead using `git add remote upstream URI` and then `git pull upstream master` inside the submodule directory. I have changed some of the submodules to suit my use-case. Almost all of the submodules are forked in my account for safe-keeping.

What I do is symlink the files in the repository to their respective spots in the home folder so as to aviod running a git repo right in my home folder.
I am including a script that will install everything where it should go.  It can be found at installers/generic.sh and should be run from inside the installers directory as `./generic.sh`. The installer is intelligent and will backup any existing stuff prior to symlinking. It will only install stuff for the application if it has been installed. So if you want my zsh configuration but use screen instead of tmux, the tmux configuration stuff won't be installed.

I am also including the font I use in my terminals DejaVuSansMono (Menlo works fine too). I've included the ttf and its license in the font directory.

With regards to terminals, on OSX, I highly recommend iTerm2. On linux I started out using tilda, then switched to guake then to rxvt-unicode (urxvt) then xterm and finally settled on Konsole. I don't particularly like having to install KDE just to use Konsole, but Konsole acts the most like iTerm2 on OSX allowing for easier cross-platform configuration and is the only linux terminal I could get to properly run the full unicode set.
