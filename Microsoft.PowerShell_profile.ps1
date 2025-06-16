if (Get-Command starship -ErrorAction SilentlyContinue) {
  Invoke-Expression (&starship init powershell)
}
else {
  Write-Host "starship is not installed or not in your PATH."
}

if (Get-Module -ListAvailable -Name cd-extras) {
  Import-Module cd-extras
} 
else {
  Write-Host "you should install module cd-extras"
}

if($IsWindows) {
  function head {
    [CmdletBinding()]
    Param([Parameter(ValueFromPipeline=$true)] $pipeline, [Int] $n = 20)
    Begin {
      $inputPipe = @()
      [System.Collections.ArrayList]$inputPipeList = $inputPipe
    }
    Process {
      $inputPipeList.Add($pipeline) | out-null
    }
    End {
      $inputPipeList | Select-Object -first $n 
    }
  }

  function tail {
    [CmdletBinding()]
    Param([Parameter(ValueFromPipeline=$true)] $pipeline, [Int] $n = 20)
    Begin {
      $inputPipe = @()
      [System.Collections.ArrayList]$inputPipeList = $inputPipe
    }
    Process {
      $inputPipeList.Add($pipeline) | out-null
    }
    End {
      $inputPipeList | Select-Object -last $n
    }
  }

  # Chocolatey profile
  $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
  if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
  }
  else {
    Write-Host "choco is not installed yet."
  }

  # rbenv for Windows
  $env:RBENV_ROOT = "C:\Ruby-on-Windows"
  $rbenvScript = "$env:RBENV_ROOT\rbenv\bin\rbenv.ps1"

  if (Test-Path($rbenvScript)) {
    # Not easy to download on Github?
    # Use a custom mirror!
    # $env:RBENV_USE_MIRROR = "https://abc.com/abc-<version>"

    & "$rbenvScript" init
  }
  else {
    Write-Host "rbenv for Windows is not installed yet or it is not in your PATH."
  }
}

Set-Alias -Name which -Value Get-Command

if (Get-Command "eza" -ErrorAction SilentlyContinue) {
  Remove-Alias ls
  function ls { eza --icons $args }
  Set-Alias -Name winls -Value Get-ChildItem
}
else {
  Write-Host "You have not installed eza yet, or it is not in your PATH."
}

if (Get-Command "bat" -ErrorAction SilentlyContinue) {
  Remove-Alias cat
  function cat { bat --color=always $args }
}
else {
  Write-Host "You have not installed bat yet, or it is not in your PATH."
}

if (Get-Command "rg" -ErrorAction SilentlyContinue) {
  function grep { rg --color=always $args }
}
elseif (Get-Command "ripgrep" -ErrorAction SilentlyContinue) {
  function grep { ripgrep --color=always $args }
}
elseif (Get-Command "grep" -ErrorAction SilentlyContinue) {
  function grep { grep --color=auto $args }
  Write-Host "Warning: 'grep' command is not ripgrep or rg, using default grep with color support."
}
else {
  Write-Host "Warning: 'grep' command is not available, please install ripgrep or grep."
}

if (Get-Command "fastfetch" -ErrorAction SilentlyContinue) {
  function neofetch { fastfetch $args }
  fastfetch
}
else {
  Write-Host "Warning: 'neofetch' command is not available, please install fastfetch."
}

if (Get-Command "gsudo" -ErrorAction SilentlyContinue) {
  Set-Alias -Name sudo -Value gsudo -Force
}
else {
  Write-Host "You have not installed gsudo yet, or it is not in your PATH."
}