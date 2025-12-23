use platform
use os
use path
use str
use builtin

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------

fn warn {|msg| echo 'Warning: '$msg }

# True if the string contains a path separator (treat as explicit path).
fn _has-path-sep {|s|
  or (str:contains $s "/") (str:contains $s "\\")
}

# Return list of executable suffixes when PATHEXT is set (Windows),
# otherwise return [].
fn _pathexts {
  var pe = $E:PATHEXT
  if (or (eq $pe $nil) (==s $pe '')) {
    put []
    return
  }

  var out = []
  # Capture str:split's multiple outputs into a list
  var parts = [(str:split ';' $pe)]

  for e $parts {
    if (==s $e '') { continue }
    if (str:has-prefix $e '.') {
      set out = (conj $out $e)
    } else {
      set out = (conj $out '.'$e)
    }
  }

  put $out
}

# Emit 1 value (full path) if found; emit 0 values if not found.
fn cmd-path {|cmd|
  # Explicit path: check directly
  if (_has-path-sep $cmd) {
    if (os:exists $cmd) { put $cmd }
    return
  }

  var exts = (_pathexts)

  # If PATHEXT exists, use Windows-style resolution:
  # try bare name, then name + each PATHEXT.
  if (> (count $exts) 0) {
    for dir $paths {
      if (or (eq $dir $nil) (==s $dir '')) { continue }

      var base = (path:join $dir $cmd)

      if (os:exists $base) { put $base; return }

      for ext $exts {
        var lowerext = (str:to-lower $ext)
        var cand = $base$lowerext
        if (os:exists $cand) { put $cand; return }
      }
    }
    return
  }

  # Unix-like: check $dir/$cmd
  for dir $paths {
    if (or (eq $dir $nil) (==s $dir '')) { continue }
    var cand = (path:join $dir $cmd)
    if (os:exists $cand) { put $cand; return }
  }
}

# True if cmd-path emits at least one value.
fn cmd-exists {|cmd|
  > (cmd-path $cmd | count) 0
}

# -----------------------------------------------------------------------------

set E:TERM = wezterm

# -----------------------------------------------------------------------------
# Vi mode + cursor shape (best-effort)
# -----------------------------------------------------------------------------
# 1 = blinking block, 3 = blinking underline, 5 = blinking bar.

fn _set-cursor {|shape|
  try {
    printf "\e["$shape" q" > ($os:dev-tty)
    edit:redraw &full=$true
  } catch e {
    # Ignore: no tty / terminal doesn't support.
  }
}

fn cursor-command { _set-cursor 1 }  # block
fn cursor-insert  { _set-cursor 5 }  # line/bar
fn cursor-replace { _set-cursor 3 }  # underscore-ish

cursor-insert

# Esc in insert -> enter command mode
set edit:insert:binding["Ctrl-["] = { cursor-command; edit:command:start }

# i in command -> back to insert
set edit:command:binding["i"] = { edit:close-mode; cursor-insert }

# a in command -> move right then back to insert (approx Vim 'a')
set edit:command:binding["a"] = { edit:move-dot-right; edit:close-mode; cursor-insert }

fn multiplex {
  if (cmd-exists tmux) {
    try { tmux -u a } catch e { tmux -u }
  } else {
    warn "'tmux' command is not available, please install tmux."
  }
}

fn spicetify {|@args|
  var exe = (path:join $E:HOME .spicetify spicetify)
  if (path:is-regular $exe) {
    e:$exe $@args
  } else {
    warn "'spicetify' command is not available, please install Spicetify."
  }
}

if (cmd-exists nvim) {
  fn vim {|@args| nvim $@args }
} else {
  warn "'nvim' command is not available, please install neovim."
}

# -----------------------------------------------------------------------------
# fastfetch/neofetch behavior
# -----------------------------------------------------------------------------

if (cmd-exists fastfetch) {
  fn neofetch {|@args| fastfetch $@args }
  neofetch
} else {
  if (cmd-exists neofetch) {
    neofetch
    warn "neofetch is no longer maintained, switch to fastfetch."
  } else {
    warn "'neofetch' command is not available, please install fastfetch."
  }
}

# -----------------------------------------------------------------------------
# ls -> eza/exa/ls with color
# -----------------------------------------------------------------------------

if (cmd-exists eza) {
  fn ls {|@args| eza --icons $@args }
} elif (cmd-exists exa) {
  fn ls {|@args| exa --icons $@args }
  warn "'exa' command is outdated, please switch to eza."
} else {
  fn ls {|@args|
    if (==s $platform:os darwin) {
      e:ls -G $@args
    } else {
      e:ls --color=auto $@args
    }
  }
  warn "'ls' command is not eza, using default ls with color support."
}

# -----------------------------------------------------------------------------
# cat -> bat/batcat/less/more
# -----------------------------------------------------------------------------

if (cmd-exists bat) {
  fn cat {|@args| bat --style=plain --color=always $@args }
} elif (cmd-exists batcat) {
  fn cat {|@args| batcat --style=plain --color=always $@args }
} elif (cmd-exists less) {
  fn cat {|@args| less --RAW-CONTROL-CHARS $@args }
  warn "'cat' command is not bat or batcat, using less with RAW-CONTROL-CHARS."
} elif (cmd-exists more) {
  fn cat {|@args| more $@args }
  warn "'cat' command is not bat or batcat, and less is not available either so using more."
} else {
  warn "'cat' command is not available, please install bat or batcat."
}

# -----------------------------------------------------------------------------
# grep -> rg/ripgrep/grep with color
# -----------------------------------------------------------------------------

if (cmd-exists rg) {
  fn grep {|@args| rg --color=always $@args }
} elif (cmd-exists ripgrep) {
  fn grep {|@args| ripgrep --color=always $@args }
} elif (cmd-exists grep) {
  fn grep {|@args| e:grep --color=auto $@args }
  warn "'grep' command is not ripgrep or rg, using default grep with color support."
} else {
  warn "'grep' command is not available, please install ripgrep or grep."
}

# zoxide
if (cmd-exists zoxide) {
  try { eval (zoxide init elvish | slurp) } catch e { }
} elif (cmd-exists z) {
  fn cd {|@args| z $@args }
}

# starship
if (cmd-exists starship) {
  try { eval (starship init elvish | slurp) } catch e { }
}

# carapace
if (cmd-exists carapace) {
  set E:CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
  try { eval (carapace _carapace elvish | slurp) } catch e { }
} else {
  warn "'carapace' is not available."
}

# atuin bindings: Up + Ctrl-R (Atuin paradigm)
if (cmd-exists atuin) {
  # Elvish is not a supported shell, so we set ATUIN_SESSION ourselves
  fn _tmpfile {|name|
    # Cross-platform temp dir
    var dir = $E:TMPDIR
    if (or (eq $dir $nil) (==s $dir '')) { set dir = $E:TEMP }
    if (or (eq $dir $nil) (==s $dir '')) { set dir = $E:TMP }
    if (or (eq $dir $nil) (==s $dir '')) { set dir = '.' }
    put (path:join $dir $name)
  }

  fn _ensure-atuin-session {
    if (or (eq $E:ATUIN_SESSION $nil) (==s $E:ATUIN_SESSION '')) {
      # atuin init doesn't support elvish; ATUIN_SESSION is usually set from `atuin uuid`
      set E:ATUIN_SESSION = (str:trim-right (e:atuin uuid | slurp) "\n")
    }
  }
  try {
    _ensure-atuin-session

    fn _atuin-search {|q|
      try {
        _ensure-atuin-session
        var tty = $os:dev-tty

        var tag = (str:trim-right (e:atuin uuid | slurp) "\n")
        var errfile = (_tmpfile 'atuin-select-'$tag'.txt')

        # IMPORTANT:
        # - stdout -> tty (so the UI is visible)
        # - stderr -> file (atuin writes the selected command to stderr) :contentReference[oaicite:1]{index=1}
        e:atuin search -i $q < $tty > $tty 2> $errfile

        var picked = (str:trim-space (slurp < $errfile))
        os:remove $errfile

        if (!=s $picked '') {
          set edit:current-command = $picked
        }
      } catch e {
        warn "atuin failed"
        # Optional: store for inspection
        set edit:exceptions = [$e $@edit:exceptions]
      }
    }

    set edit:insert:binding["Up"]      = { _atuin-search $edit:current-command }
    set edit:history:binding["Up"]     = { _atuin-search $edit:current-command }
    set edit:command:binding["Up"]     = { _atuin-search $edit:current-command }
    set edit:insert:binding["Ctrl-R"]  = { _atuin-search '' }
    set edit:command:binding["Ctrl-R"] = { _atuin-search '' }

  } catch e {
    warn "atuin uuid failed; ATUIN_SESSION not set"
  }
} else {
  warn "'atuin' is not available."
}

# -----------------------------------------------------------------------------
# volta + PATH tweaks
# -----------------------------------------------------------------------------

if (cmd-exists volta) {
  set E:VOLTA_HOME = (path:join $E:HOME .volta)
  set paths = [(path:join $E:VOLTA_HOME bin) $@paths]
}

var localbin = (path:join $E:HOME .local bin)
if (and (path:is-dir $localbin) (not (has-value $paths $localbin))) {
  set paths = [$@paths $localbin]
}

# -----------------------------------------------------------------------------
# os agnostic which command
# -----------------------------------------------------------------------------

# A "which/type"-like helper:
# - external commands -> prints full path
# - functions -> reports whether builtin or user-defined
# - otherwise -> fails
fn which {|name|
  # resolve outputs a symbolic representation like:
  #   '$cmd-path~'     (function)
  #   '(external nvim)' (external)
  var sym = (resolve $name)

  if (==s $name 'which') {
    # Avoid infinite recursion
    put 'which is an elvish function'
    return
  }

  if (and (str:has-prefix $sym '$') (str:has-suffix $sym '~')) {
    put $name' is an elvish function'
    return
  }
  # Use your proven external resolver
  if (cmd-exists $name) {
    cmd-path $name
  } else {
    # Fallback: show whatever resolve returned
    put 'which: '$name': not found'
  }
}