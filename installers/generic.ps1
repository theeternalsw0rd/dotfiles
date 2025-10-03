$adminCheck = [Security.Principal.WindowsPrincipal]([Security.Principal.WindowsIdentity]::GetCurrent())
$isElevated = $adminCheck.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$targetDirectory = (get-item $PSScriptRoot ).parent.FullName
if ($isElevated) {
  $pwshProfile = $targetDirectory + "\Microsoft.Powershell_profile.ps1"
  if (!(Test-Path -Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE -Force }
  Remove-Item -Path $PROFILE
  New-Item -ItemType SymbolicLink -Path $PROFILE -Target $pwshProfile
}
else {
  Write-Host "installing powershell profile utilizes symbolic links. script must be run elevated to have necessary privileges to do so."
}
if (Get-Command "starship" -ErrorAction SilentlyContinue) {
  if($isElevated) {
    $starshipConfig = $targetDirectory + "\starship.toml"
    $starshipLinkDirectory = $env:USERPROFILE + "\.config"
    if (-not (Test-Path -Path $starshipLinkDirectory))
    {
      New-Item -Path $starshipLinkDirectory -ItemType Directory
    }
    $starshipLink = $starshipLinkDirectory + "\starship.toml"
    if (Test-Path -Path $starshipLink) {
      Remove-Item -Path $starshipLink
    }
    New-Item -ItemType SymbolicLink -Path $starshipLink -Target $starshipConfig
    Write-Host "starship.toml has been installed"
  }
  else {
    "installing starship configuration file utilizes symbolic links. script must be run elevated to have necessary privileges to do so."
  }
}
else {
  Write-Host "starship is not available in your system path and may not be installed. get that corrected and then rerun this script."
}
if (Get-Command "nu" -ErrorAction SilentlyContinue) {
  if($isElevated) {
    $nuConfig = $targetDirectory + "\config.nu"
    $nuLinkDirectory = $env:APPDATA + "\nushell"
    if (-not (Test-Path -Path $nuLinkDirectory))
    {
      New-Item -Path $nuLinkDirectory -ItemType Directory
    }
    $nuLink = $nuLinkDirectory + "\config.nu"
    if (Test-Path -Path $nuLink) {
      Remove-Item -Path $nuLink
    }
    New-Item -ItemType SymbolicLink -Path $nuLink -Target $nuConfig
    Write-Host "config.nu has been installed"
  }
  else {
    "installing nu configuration file utilizes symbolic links. script must be run elevated to have necessary privileges to do so."
  }
}
else {
  Write-Host "nushell is not available in your system path and may not be installed. get that corrected and then rerun this script."
}
if (Get-Command "yazi" -ErrorAction SilentlyContinue) {
  if($isElevated) {
    $yaziConfig = $targetDirectory + "\yazi"
    $yaziLinkDirectory = $env:USERPROFILE + "\.config"
    if (-not (Test-Path -Path $yaziLinkDirectory))
    {
      New-Item -Path $yaziLinkDirectory -ItemType Directory
    }
    $yaziLink = $yaziLinkDirectory + "\yazi"
    if (Test-Path -Path $yaziLink) {
      Remove-Item -Path $yaziLink
    }
    New-Item -ItemType SymbolicLink -Path $yaziLink -Target $yaziConfig
    Write-Host "yazi configuration has been installed"
  }
  else {
    "installing yazi configuration files utilizes symbolic links. script must be run elevated to have necessary privileges to do so."
  }
}
else {
  Write-Host "yazi is not available in your system path and may not be installed. get that corrected and then rerun this script."
}
if (Get-Command "wtq.exe" -ErrorAction SilentlyContinue) {
  if ($isElevated) {
    $wtqConfig = $targetDirectory + "\wtq.jsonc"
    $wtqLinkDirectory = $env:APPDATA + "\wtq"
    if (-not (Test-Path -Path $wtqLinkDirectory)) {
      New-Item -Path $wtqLinkDirectory -ItemType Directory
    }
    $wtqLink = $wtqLinkDirectory + "\wtq.jsonc"
    if (Test-Path -Path $wtqLink) {
      Remove-Item -Path $wtqLink
    }
    New-Item -ItemType SymbolicLink -Path $wtqLink -Target $wtqConfig
    Write-Host "wtq.jsonc has been installed"
  }
  else {
    Write-Host "installing wtq configuration file utilizes symbolic links. script must be run elevated to have necessary privileges to do so."
  }
}
else {
  Write-Host "wtq is not available in your system path and may not be installed. get that corrected and then rerun this script."
}
if (Get-Command "wezterm.exe" -ErrorAction SilentlyContinue) {
  if ($isElevated) {
    $weztermConfig = $targetDirectory + "\wezterm-config"
    $weztermLinkDirectory = $env:USERPROFILE + "\.config"
    if (-not (Test-Path -Path $weztermLinkDirectory)) {
      New-Item -Path $weztermLinkDirectory -ItemType Directory
    }
    $weztermLink = $weztermLinkDirectory + "\wezterm"
    if (Test-Path -Path $weztermLink) {
      Remove-Item -Path $weztermLink
    }
    New-Item -ItemType SymbolicLink -Path $weztermLink -Target $weztermConfig
    Write-Host "wezterm configuration Has Been Installed"
  }
  else {
    Write-Host "installing wezterm configuration files utilizes symbolic links. script must be run elevated to have necessary privileges to do so."
  }
}
else {
  Write-Host "wezterm is not available in your system path and may not be installed. get that corrected and then rerun this script."
}
if (Get-Command "nvim.exe" -ErrorAction SilentlyContinue) {
  if ($isElevated) {
    $nvimConfig = $targetDirectory + "\nvim"
    $nvimLinkDirectory = $env:LOCALAPPDATA
    if (-not (Test-Path -Path $nvimLinkDirectory)) {
      New-Item -Path $nvimLinkDirectory -ItemType Directory
    }
    $nvimLink = $nvimLinkDirectory + "\nvim"
    if (Test-Path -Path $nvimLink) {
      Remove-Item -Path $nvimLink
    }
    New-Item -ItemType SymbolicLink -Path $nvimLink -Target $nvimConfig
    Write-Host "nvim configuration Has Been Installed"
  }
  else {
    Write-Host "installing nvim configuration files utilizes symbolic links. script must be run elevated to have necessary privileges to do so."
  }
}
else {
  Write-Host "nvim is not available in your system path and may not be installed. get that corrected and then rerun this script."
}
if ($isElevated) {
  $yasbConfig = $targetDirectory + "\yasb"
  $yasbLinkDirectory = $env:USERPROFILE + "\.config"
  if (-not (Test-Path -Path $yasbLinkDirectory)) {
    New-Item -Path $yasbLinkDirectory -ItemType Directory
  }
  $yasbLink = $yasbLinkDirectory + "\yasb"
  if (Test-Path -Path $yasbLink) {
    Remove-Item -Path $yasbLink
  }
  New-Item -ItemType SymbolicLink -Path $yasbLink -Target $yasbConfig
  Write-Host "yasb configuration has been installed"
}
else {
  Write-Host "installing yasb configuration files utilizes symbolic links. script must be run elevated to have necessary privileges to do so."
}
if (Get-Command "fastfetch.exe" -ErrorAction SilentlyContinue) {
  if ($isElevated) {
    $fastfetchConfig = $targetDirectory + "\fastfetch"
    $winver = (Get-WmiObject Win32_OperatingSystem).Caption -replace '\D', ''
    Copy-Item "$fastfetchConfig\pngs\windows$winver-chan.png" $fastfetchConfig\pngs\os-chan.png -Force
    $fastfetchLinkDirectory = $env:USERPROFILE + "\.config"
    if (-not (Test-Path -Path $fastfetchLinkDirectory)) {
      New-Item -Path $fastfetchLinkDirectory -ItemType Directory
    }
    $fastfetchLink = $fastfetchLinkDirectory + "\fastfetch"
    if (Test-Path -Path $fastfetchLink) {
      Remove-Item -Path $fastfetchLink
    }
    New-Item -ItemType SymbolicLink -Path $fastfetchLink -Target $fastfetchConfig
    Write-Host "fastfetch configuration has been installed"
  }
} else {
  Write-Host "fastfetch is not available in your system path and may not be installed. get that corrected and then rerun this script."
}
if (Get-Command "git.exe" -ErrorAction SilentlyContinue) {
  $gitignore = $targetDirectory + "\gitignore_global.conf"
  git config --global user.name "Micah Bucy"
  git config --global user.email "micah.bucy@theeternalsw0rd.rocks"
	git config --global init.defaultBranch main
  git config --global core.excludesfile "$gitignore"
  Write-Host "global git configuration values set"
}
else {
  Write-Host "git is not available in your system path and may not be installed. get that corrected and then rerun this script"
}
if(Get-Command "code" -ErrorAction SilentlyContinue) {
  if($env:EDITOR -ne "code") {
    [Environment]::SetEnvironmentVariable('EDITOR', 'code', 'User')
  }
}
else {
  Write-Host "Visual Studio Code is not yet installed. Not setting EDITOR environment variable."
}
if(Get-Command "pwsh" -ErrorAction SilentlyContinue) {
  if($env:SHELL -ne "pwsh") {
    [Environment]::SetEnvironmentVariable('SHELL', 'pwsh', 'User')
  }
}
else {
  Write-Host "pwsh is not installed. You should really be using pwsh instead of the built-in powershell. Not setting SHELL environment variable."
}
if(Get-Command "audition" -ErrorAction SilentlyContinue) {
  if($env:MUSICEDITOR -ne "audition") {
    [Environment]::SetEnvironmentVariable('MUSICEDITOR', 'audition', 'User')
  }
}
else {
  Write-Host "audition is not available as a command. Please make sure Adobe Audition is installed and audition.exe is an available symlink in your PATH to the Adobe Audition executable."
}
if(Get-Command "gimp" -ErrorAction SilentlyContinue) {
  if($env:IMAGEEDITOR -ne "gimp") {
    [Environment]::SetEnvironmentVariable('IMAGEEDITOR', 'gimp', 'User')
  }
}
else {
  Write-Host "gimp is not available in PATH, make sure it is installed globally and add its bin directory to PATH."
}