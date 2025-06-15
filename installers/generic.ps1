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
if (Get-Command "git.exe" -ErrorAction SilentlyContinue) {
    $gitignore = $targetDirectory + "\gitignore.conf"
    git config --global user.name "Micah Bucy"
    git config --global user.email "micah.bucy@theeternalsw0rd.rocks"
    git config --global core.excludeFiles "$gitignore"
    Write-Host "global git configuration values set"
}
else {
    Write-Host "git is not available in your system path and may not be installed. get that corrected and then rerun this script"
}