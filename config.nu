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

def 'is-installed' [ app: string ] {
  ((which $app | length) > 0)
}

if (is-installed nvim) {
    $env.config.buffer_editor = "nvim"
    alias vim = nvim
    alias vi = nvim
} else {
    echo "neovim is not installed or available in path. it is required for setting the buffer_editor"
}

if (is-installed eza) {
    alias ls = eza --icons
}
else {
    echo "eza is not installed or available in path."
}

if (is-installed rg) {
    alias grep = rg
}
elseif (is-installed ripgrep) {
    alias grep = ripgrep
}
else {
    echo "ripgrep is not installed or available in path."
}

if (is-installed bat) {
    alias cat = bat
}
elseif (is-installed batcat) {
    alias cat = batcat
}
else {
    echo "bat is not installed or available in path."
}

if (is-installed yazi) {
    alias fm = yazi
}
else {
    echo "yazi is not installed or available in path."
}

mkdir ($nu.data-dir | path join "vendor/autoload")

if (is-installed zoxide) {
    zoxide init --cmd cd nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")
}
else {
    echo "zoxide is not installed or available in path."
}

if (is-installed starship) {
    starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
} else {
    echo "starship is not installed or available in path. it is required for fancy prompt."
}