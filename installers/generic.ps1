$adminCheck = [Security.Principal.WindowsPrincipal]([Security.Principal.WindowsIdentity]::GetCurrent())
$isElevated = $adminCheck.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$targetDirectory = (get-item $PSScriptRoot ).parent.FullName
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
        Write-Host "wtq.jsonc Has Been Installed"
    }
    else {
        Write-Host "installing wtq configuration file utilizes symbolic links. script must be run elevated to have necessary privileges to do so."
    }
}
else {
    Write-Host "wtq is not available in your system path and may not be installed. get that corrected and then rerun this script."
}
if (Get-Command "wezterm.exe" -ErrorAction SilentlyContinue) {
    $weztermConfig = $targetDirectory + "\wezterm-config\wezterm.lua"
    [Environment]::SetEnvironmentVariable("WEZTERM_CONFIG_FILE", $weztermConfig, "User")
    Write-Host "WEZTERM_CONFIG_FILE user environment variable has been set."
}
else {
    Write-Host "wezterm is not available in your system path and may not be installed. get that corrected and then rerun this script."
}
if (Get-Command "git.exe" -ErrorAction SilentlyContinue) {
    $gitignore = $targetDirectory + "\gitignore.conf"
    git config --global user.name "Micah Bucy"
    git config --global user.email "micah.bucy@theeternalsw0rd.rocks"
    git config --global core.excludeFiles "$gitignore"
    Write-Host "global git configuration values set"
}
else {
    Write-Host "git is not available. please install and then rerun this script"
}