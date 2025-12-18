# dotfiles

dot file configurations

Do a recursive checkout `git clone --recursive https://github.com/theeternalsw0rd/dotfiles.git`

Or if you already have cloned it and the subdirectories are empty, run `git submodule update --init --recursive`

Keep in mind the limitations of submodules. If you want to update any of the submodules, create a branch and make your changes there or at least `git checkout master` first.

This repository contains general configurations only. Local machine-specific configurations should be stored in the appropriate local files. Also put anything with usernames, ips, passwords, etc in there so as to avoid making it public.

If you find my submodules to be out of date, you can add the upstream versions instead using `git add remote upstream URI` and then `git pull upstream master` inside the submodule directory. I have changed some of the submodules to suit my use-case. Almost all of the submodules are forked in my account for safe-keeping.

What I do is symlink the files in the repository to their respective spots in the home folder so as to aviod running a git repo right in my home folder.
I am including a script that will install everything where it should go. It can be found at installers/generic.sh and should be run from inside the installers directory as `./generic.sh`. The installer is intelligent and will backup any existing stuff prior to symlinking. It will only install stuff for the application if it has been installed. So if you want my zsh configuration but use screen instead of tmux, the tmux configuration stuff won't be installed.

I have switched to using fish on linux and macOS, so my zsh configuration is out of date. On Windows I use Powershell Core or fish from wsl. I have a powershell installer script which is for use on Windows only. On linux, within wsl, and macOS, generic.sh should be used for the install. If you use nushell, you should install that early on when prepping a new machine or stuff like rustup might not be configured properly.

I use WezTerm on all platforms I use. Pretty much any nerdfont should work with my setup. I use Fantasque Sans M as my font. I use windows-terminal-quake on Windows for a quake style WezTerm and for opacity. I am in the midst of changing desktop environments on Linux and will update configurations when I reach stability.

I use the following AppleScript saved as an application and then use Automator action to assign a global keystroke to it to get quake style WezTerm.

```
set appName to "WezTerm"

if not (application appName is running) then
	tell application appName
		activate
	end tell
	tell application "System Events"
		set frontmost of application process appName to true
	end tell
else
	tell application "System Events"
		if visible of application process appName is true then
			set visible of application process appName to false
		else
			set visible of application process appName to true
			set frontmost of application process appName to true
		end if
	end tell
end if
```

If you use Spaces, make sure WezTerm is set to show on all Spaces, so it doesn't matter which Space you are on. Only thing that doesn't work currently is it doesn't automatically hide when losing focus, so if WezTerm loses focus, you will need to hit the hotkey twice. I tried using both Phoenix and Hammerspoon, but couldn't get either to work correctly. Opacity is set in WezTerm config as Metal consistently works.
