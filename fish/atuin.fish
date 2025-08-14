if type -q atuin
  atuin init fish | source
else
  echo "Warning: 'atuin' is not available."
end
