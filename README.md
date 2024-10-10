# dotfiles

dot file configurations

Do a recursive checkout `git clone --recursive https://github.com/theeternalsw0rd/dotfiles.git`

Or if you already have cloned it and the subdirectories are empty, run `git submodule update --init --recursive`

Keep in mind the limitations of submodules. If you want to update any of the submodules, create a branch and make your changes there or at least `git checkout master` first.

This repository contains general configurations only. Local machine-specific configurations should be stored in the appropriate local files. Also put anything with usernames, ips, passwords, etc in there so as to avoid making it public.

If you find my submodules to be out of date, you can add the upstream versions instead using `git add remote upstream URI` and then `git pull upstream master` inside the submodule directory. I have changed some of the submodules to suit my use-case. Almost all of the submodules are forked in my account for safe-keeping.

What I do is symlink the files in the repository to their respective spots in the home folder so as to aviod running a git repo right in my home folder.
I am including a script that will install everything where it should go. It can be found at installers/generic.sh and should be run from inside the installers directory as `./generic.sh`. The installer is intelligent and will backup any existing stuff prior to symlinking. It will only install stuff for the application if it has been installed. So if you want my zsh configuration but use screen instead of tmux, the tmux configuration stuff won't be installed.

I'm not on macOS much these days. I use kitty on linux and KDE as my DE. I've added an installer for a kwallet git credential helper. If I start using macOS more, I assume I would use kitty. Pretty much any nerdfont should work with my setup. I use FiraCode Mono. I use wezterm on Windows and my config is included here. I haven't written an installer for that yet, but powershell can be used to create a soft-link.
