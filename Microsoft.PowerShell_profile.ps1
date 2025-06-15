if (Get-Command starship -ErrorAction SilentlyContinue) {
  Invoke-Expression (&starship init powershell)
}
else {
  Write-Host "you should install starship"
}
if (Get-Module -ListAvailable -Name cd-extras) {
  Import-Module cd-extras
} 
else {
  Write-Host "you should install module cd-extras"
}

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

if($IsWindows) {
  # Chocolatey profile
  $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
  if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
  }
  else {
    Write-Host "choco is not installed yet."
  }
}

Set-Alias -Name which -Value Get-Command

if($IsWindows) {
  # rbenv for Windows
  $env:RBENV_ROOT = "C:\Ruby-on-Windows"
  $rbenvScript = "$env:RBENV_ROOT\rbenv\bin\rbenv.ps1"

  if (Test-Path($rbenvScript)) {
    # Not easy to download on Github?
    # Use a custom mirror!
    # $env:RBENV_USE_MIRROR = "https://abc.com/abc-<version>"

    & "$rbenvScript" init
  }
}

if (Get-Command "eza" -ErrorAction SilentlyContinue) {
  Remove-Alias ls
  function ls { eza --icons $args }
  Set-Alias -Name winls -Value Get-ChildItem
}

else {
  Write-Host "You have not installed eza yet, or it is not in your PATH."
}

if (Get-Command "gsudo" - -ErrorAction SilentlyContinue) {
  Set-Alias -Name sudo -Value gsudo -Force
}