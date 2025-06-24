# config.nu
#
# Installed by:
# version = "0.105.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

def --wrapped 'vim' [...rest] {
    if not (which nvim | is-empty) {
        ^nvim ...$rest
    } else {
        print "neovim is not installed or available in path"
        ^vim ...$rest
    }
}

def --wrapped 'vi' [...rest] {
    if not (which nvim | is-empty) {
        ^nvim ...$rest
    } else {
        print "neovim is not installed or available in path"
        ^vi ...$rest
    }
}

if not (which nvim | is-empty) {
    $env.config.buffer_editor = "nvim"
}

alias nuls = ls

def --wrapped 'ls' [...rest] {
    if not (which eza | is-empty) {
        ^eza --icons ...$rest
    } else {
        if not (which exa | is-empty) {
            print "still using exa which is unmaintained. use eza."
            ^exa --icons ...$rest
        }
        else {
            ^ls ...$rest
        }
    }
}

def --wrapped 'grep' [...rest] {
    if not (which rg | is-empty) {
        ^rg ...$rest
    } else {
        if not (which ripgrep | is-empty) {
            ^ripgrep ...$rest
        } else {
            print "ripgrep not installed. using standard grep."
            ^grep ...$rest
        }
    }
}

def --wrapped 'cat' [...rest] {
    if not (which bat | is-empty) {
        ^bat ...$rest
    } else {
        if not (which batcat | is-empty) {
            ^batcat ...$rest
        } else {
            print "batcat is not installed or available in the path. using nu-shell's open command"
            ^open ...$rest
        }
    }
}

def --wrapped 'fm' [...rest] {
    if not (which yazi | is-empty) {
        ^yazi ...$rest
    } else {
        print "yazi is not installed or available in the path."
    }
}

alias neofetch = fastfetch

mkdir ($nu.data-dir | path join "vendor/autoload")

if not (which zoxide | is-empty) {
    zoxide init --cmd cd nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")
} else {
    print "zoxide is not installed or available in path."
}

if not (which starship | is-empty) {
    starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
} else {
    print "starship is not installed or available in path. it is required for fancy prompt."
}

if not (which fastfetch | is-empty) {
    fastfetch
}