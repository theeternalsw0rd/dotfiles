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

if type -q fastfetch
    # Use fastfetch as a replacement for neofetch if available
    function neofetch
        command fastfetch $argv
    end
    fastfetch
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
else if type -q more
    # Use more as a replacement for cat if available
    function cat
        command more $argv
    end
end

if type -q rg
    # Use ripgrep as a replacement for grep if available
    function grep
        command rg --color=always $argv
    end
else if type -q grep
    # Use grep with color support if available
    function grep
        command grep --color=auto $argv
    end
end

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