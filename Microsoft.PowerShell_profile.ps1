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
      if (Get-Command "bat" -ErrorAction SilentlyContinue) {
        $inputPipeList | Select-Object -first $n | bat --color=always --paging=never
      }
      else {
        $inputPipeList | Select-Object -first $n
      }
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
      if (Get-Command "bat" -ErrorAction SilentlyContinue) {
        $inputPipeList | Select-Object -last $n | bat --color=always --paging=never
      }
      else {
        $inputPipeList | Select-Object -last $n
      }
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

  # Invokes a Cmd.exe shell script and updates the environment.
  # This is useful for loading MSVC environment variables.
  # https://stackoverflow.com/questions/41399692/running-a-build-script-after-calling-vcvarsall-bat-from-powershell
  # Original article is not available anymore or is behind a paywall.
  # Usage: Invoke-CmdScript "C:\path\to\script.bat" arg1 arg2
  function Invoke-CmdScript {
    param(
      [String] $scriptName
    )
    $cmdLine = """$scriptName"" $args & set"
    & $Env:SystemRoot\system32\cmd.exe /c $cmdLine |
    select-string '^([^=]*)=(.*)$' | foreach-object {
      $varName = $_.Matches[0].Groups[1].Value
      $varValue = $_.Matches[0].Groups[2].Value
      set-item Env:$varName $varValue
    }
  }

  function UnloadToolChain {
    if (Get-Command "refreshenv" -ErrorAction SilentlyContinue) {
      refreshenv
    }
    else {
      Write-Host "refreshenv command not found, please install chocolatey or manually reset your environment."
    }
  }

  function LoadMSVC {
    # load x64 by default but allow specifying an architecture
    [CmdletBinding()]
    Param([string] $arch = "x64")
    if ($arch -notin @("x64", "x86", "arm64")) {
      Write-Host "Invalid architecture: $arch. Supported architectures are x64, x86, arm64."
      return
    }
    $vcvarsall = "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat"
    if (Test-Path $vcvarsall) {
        Invoke-CmdScript "$vcvarsall" $arch
        Write-Host "Visual Studio environment variables loaded for $arch."
    }
    else {
      Write-Host "Visual Studio not found."
    }
  }
  function UnloadMSVC {
    UnloadToolChain
  }

  function LoadMsys2 {
    $mingwPath = "C:\Ruby-on-Windows\msys64"
    if (Test-Path $mingwPath) {
      $env:PATH = "$mingwPath\usr\bin;$mingwPath\ucrt64\bin;$mingwPath\ucrt64\lib;$env:PATH"
      Write-Host "MinGW environment variables loaded."
    }
    else {
      Write-Host "MinGW not found."
    }
  }
  function UnloadMsys2 {
    UnloadToolChain
  }
  function wget {
    [CmdletBinding()]
    Param([string] $url, [string] $output = $null)

    if (-not $url) {
      Write-Host "Usage: wget <url> [<output>]"
      return
    }
    # check if the URL is valid
    if (-not $url -or $url -notmatch '^(http|https)://') {
      Write-Host "Invalid URL: $url"
      return
    }

    if (-not $output) {
      # if no output is specified, use the current directory and the file name from the URL
      # get name of file from URL after last slash but before query string unless slash is the final character
      # if the URL ends with a slash remove the last slash and try again
      if ($url.EndsWith('/')) {
        $url = $url.Substring(0, $url.Length - 1)
      }
      $fileName = $url -replace '.*/', '' -replace '\?.*', ''
      $currentDirectory = Get-Location
      $path = "$currentDirectory\$fileName"
      Try { [io.file]::OpenWrite($path).close() }
      Catch { 
        Write-Host "Cannot write to $path, using user download directory instead."
        $currentDirectory = "$env:USERPROFILE\Downloads"
        $path = "$currentDirectory\$fileName"
      }
    }
    else {
      $path = $output
      $fileName = [io.path]::GetFileName($path)
      # strip trailing whitespace to aviod Windows not being able to delete or rename the file
      $fileName = $fileName.TrimEnd()
      # make sure fileName uses characters suppoorted by Windows
      if ($fileName -match '[<>:"/\\|?*]') {
        Write-Host "Invalid file name: $fileName"
        return
      }
      # check if the output path is writable
      Try { [io.file]::OpenWrite($path).close() }
      Catch { 
        Write-Host "Cannot write to $path"
        $currentDirectory = "$env:USERPROFILE\Downloads"
        $path = "$currentDirectory\$fileName"
        Write-Host "Using user download directory instead: $path"
      }
    }

    if (Get-Command "Start-BitsTransfer" -ErrorAction SilentlyContinue) {
      Start-BitsTransfer -Source $url -Destination $path -ErrorAction Stop
      if ($?) {
        Write-Host "Downloaded $fileName to $path"
      }
      else {
        Write-Host "Failed to download $fileName from $url"
      }
    }
    else {
      Write-Host "Start-BitsTransfer is not available, using Invoke-WebRequest instead."
      Invoke-WebRequest -Uri $url -OutFile $path -ErrorAction Stop
      if ($?) {
        Write-Host "Downloaded $fileName to $path"
      }
      else {
        Write-Host "Failed to download $fileName from $url"
      }
    }
  }
}
else {
  function LoadMSVC {
    Write-Host "LoadMSVC is not supported on non-Windows systems."
  }
  function LoadMsys2 {
    Write-Host "LoadMsys2 is not supported on non-Windows systems."
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
  function cat {
    if($input) {
      $input | bat --color=always $args
    }
    else {
      bat --color=always $args
    }
  }
}
else {
  Write-Host "You have not installed bat yet, or it is not in your PATH."
}

if (Get-Command "rg" -ErrorAction SilentlyContinue) {
  # create a function named grep that uses ripgrep (rg) with color support and allow receiving data piped from other commands
  function grep {
    if ($input) {
      $input | rg --color=always $args
    }
    else {
      rg --color=always $args
    }
  }
}
elseif (Get-Command "ripgrep" -ErrorAction SilentlyContinue) {
  function grep { 
    if ($input) {
      $input | ripgrep --color=always $args
    }
    else {
      ripgrep --color=always $args
    }
  }
}
elseif (Get-Command "grep" -ErrorAction SilentlyContinue) {
  function grep {
    if($input) {
      $input | grep --color=auto $args
    }
    else {
      grep --color=auto $args
    }
  }
  Write-Host "Warning: 'grep' command is not ripgrep or rg, using default grep with color support."
}
else {
  Write-Host "Warning: 'grep' command is not available, please install ripgrep or grep."
}

if (Get-Command "fastfetch" -ErrorAction SilentlyContinue) {
  function neofetch { fastfetch $args }
  fastfetch --logo "$env:USERPROFILE\.config\fastfetch\pngs\windows11-chan.png" --logo-type "iterm" --logo-height 25 --logo-width 35
}
else {
  Write-Host "Warning: 'neofetch' command is not available, please install fastfetch."
}

if (Get-Command "gsudo" -ErrorAction SilentlyContinue) {
  Set-Alias -Name sudo -Value gsudo -Force
  if (Get-Command "btop4win" -ErrorAction SilentlyContinue) {
    function btop { gsudo btop4win }
  }
  else {
    Write-Host "You have not installed btop4win yet, or it is not in your PATH."
  }
}
else {
  Write-Host "You have not installed gsudo yet, or it is not in your PATH."
}

Set-PSReadLineOption -EditMode vi

if (Get-Command atuin -ErrorAction SilentlyContinue) {
    atuin init powershell | Out-String | Invoke-Expression
}
else {
  Write-Host "atuin is not installed or not in your PATH."
}
