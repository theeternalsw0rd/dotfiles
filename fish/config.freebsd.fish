# nodejs has no official binaries for bsd flavors
# so we must use package manager for installing

set -gx PYENV_ROOT "$HOME/.pyenv"
set -gx PATH "$PYENV_ROOT/bin" $PATH
source (pyenv init - | psub)
source (pyenv virtualenv-init - | psub)

set -gx PATH "$HOME/.rbenv/bin" $PATH
set -gx PATH "$HOME/.rbenv/shims" $PATH
set -gx RBENV_SHELL fish
command rbenv rehash 2>/dev/null
function rbenv
  set command $argv[1]
  set -e argv[1]

  switch "$command"
  case rehash shell
    rbenv "sh-$command" $argv|source
  case '*'
    command rbenv "$command" $argv
  end
end

set -gx PATH "~/.local/bin" $PATH

if type -q clang
  set -gx CC clang
else
  echo "Warning: FreeBSD should have clang installed"
end
