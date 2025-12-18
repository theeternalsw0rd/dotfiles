# Emulates vim's cursor shape behavior
# Set the normal and visual mode cursors to a block
set fish_cursor_default block blink
# Set the insert mode cursor to a line
set fish_cursor_insert line blink
# Set the replace mode cursors to an underscore
set fish_cursor_replace_one underscore
set fish_cursor_replace underscore
# Set the external cursor to a line. The external cursor appears when a command is started.
# The cursor shape takes the value of fish_cursor_default when fish_cursor_external is not specified.
set fish_cursor_external line
# The following variable can be used to configure cursor shape in
# visual mode, but due to fish_cursor_default, is redundant here
set fish_cursor_visual block

# Then execute the vi-bindings so they take precedence when there's a conflict.
# Without --no-erase fish_vi_key_bindings will default to
# resetting all bindings.
# The argument specifies the initial mode (insert, "default" or visual).
fish_vi_key_bindings insert

# Suppress fish welcome message
set -U fish_greeting ""

alias which=type
alias multiplex="tmux -u a || tmux -u"

if test -e ~/.spicetify/spicetify
    function spicetify
        ~/.spicetify/spicetify $argv
    end
else 
    echo "Warning: 'spicetify' command is not available, please install Spicetify."
end

set -gx TERM wezterm

if type -q nvim
    alias vim=nvim
else
    echo "Warning: 'nvim' command is not available, please install neovim."
end
if type -q fastfetch
    # Use fastfetch as a replacement for neofetch if available
    function neofetch
        command fastfetch $argv
    end
    if status is-interactive
        neofetch
    end
else
    if type -q neofetch
        if status is-interactive
            neofetch
        end
        echo "Warning: neofetch is no longer maintained, switch to fastfetch."
    else
        echo "Warning: 'neofetch' command is not available, please install fastfetch."
    end
end

if type -q eza
    # Use eza as a replacement for ls if available
    function ls
        command eza --icons $argv
    end
else if type -q exa
    # Use exa as a replacement for ls if available
    function ls
        command exa --icons $argv
    end
    echo "Warning: 'exa' command is outdated, please switch to eza."
else
    # Use ls with color support if available
    function ls
        command ls --color=auto $argv
    end
    echo "Warning: 'ls' command is not eza, using default ls with color support."
end

if type -q bat
    # Use bat as a replacement for cat if available
    function cat
        command bat --style=plain --color=always $argv
    end
else if type -q batcat
    # Use batcat as a replacement for cat if available
    function cat
        command batcat --style=plain --color=always $argv
    end
else if type -q less
    # Use less as a replacement for cat if available
    function cat
        command less --RAW-CONTROL-CHARS $argv
    end
    echo "Warning: 'cat' command is not bat or batcat, using less with RAW-CONTROL-CHARS."
else if type -q more
    # Use more as a replacement for cat if available
    function cat
        command more $argv
    end
    echo "Warning: 'cat' command is not bat or batcat, and less is not available either so using more."
else
    echo "Warning: 'cat' command is not available, please install bat or batcat."
end

if type -q rg
    # Use ripgrep as a replacement for grep if available
    function grep
        command rg --color=always $argv
    end
else if type -q ripgrep
    # Use ripgrep as a replacement for grep if available
    function grep
        command ripgrep --color=always $argv
    end
else if type -q grep
    # Use grep with color support if available
    function grep
        command grep --color=auto $argv
    end
    echo "Warning: 'grep' command is not ripgrep or rg, using default grep with color support."
else
    echo "Warning: 'grep' command is not available, please install ripgrep or grep."
end

if status is-interactive
    if type -q zoxide
        # Use zoxide as a replacement for cd if available
        zoxide init --cmd cd fish | source
    else if type -q z
        # Use z as a replacement for cd if available
        function cd
            command z $argv
        end
    end

    if type -q starship
        starship init fish | source
    end

    if type -q atuin
        set -l __atuin_init (atuin init fish | string replace -ra -- 'bind -M ([^ ]+)\s+-k ' 'bind -M $1 ' | string replace -ra -- 'bind\s+-k ' 'bind ')
        if test -n "$__atuin_init"
            printf '%s\n' $__atuin_init | source
            if functions -q _atuin_bind_up
                bind up _atuin_bind_up
                bind -M insert up _atuin_bind_up
            end
        else
            # fallback: source unmodified but silence deprecation noise
            atuin init fish 2>/dev/null | source
        end
    else
        echo "Warning: 'atuin' is not available."
    end
end
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

export PATH="$PATH:$HOME/.local/bin"
