$Env:YAZI_FILE_ONE = "C:\Program Files\Git\usr\bin\file.exe"
$Env:YAZI_FILE_HOME = "C:\Users\Hugo\AppData\Roaming\yazi\config"
$Env:KOMOREBI_CONFIG_HOME = 'C:\Users\Hugo\.config\komorebi'

Remove-Item Alias:diff -Force -ErrorAction SilentlyContinue
Remove-Item Alias:sl -Force -ErrorAction SilentlyContinue

function c { Set-Location -Path C:\ }
function d { Set-Location -Path D:\ }
function j { Set-Location -Path J:\ }
function k { Set-Location -Path K:\ }

function docu { Set-Location "D:\Users\Hugo\Documents" }

function desk { Set-Location "D:\Users\Hugo\Desktop" }

function pics { Set-Location "D:\Users\Hugo\Pictures" }

function musi { Set-Location "D:\Users\Hugo\Music" }

function vids { Set-Location "J:\Videos" }

function bin { Set-Location "C:\tools\bin" }

function wtr { curl https://wttr.in/sobradinho%20distrito%20federal }

function wd { $pwd.Path }

function ani { wsl ani-cli $args }

function tv { luffy $args -b -a play }

function yt { luffy $args -b -a play -p youtube }

function la { Get-ChildItem -Path . -Force | Format-Table -AutoSize }

Set-Alias chmod -Value icacls.exe

Set-Alias gg -Value gemini

Set-Alias df -Value get-volume

Set-Alias -Name showdns -Value Get-DnsClient 

Set-Alias -Name list -Value Get-ChildItem

Set-Alias -Name ll -Value Get-ChildItem

Set-Alias -Name sysinfo -Value Get-ComputerInfo

Set-Alias -Name htop -Value ntop

function dnsflush {
    Clear-DnsClientCache
    Write-Host "DNS has been flushed"
}

# Quick Access to Editing the Profile
function Edit-Profile {
    nvim $PROFILE.CurrentUserAllHosts
}

Set-Alias -Name ep -Value Edit-Profile

function edit-terminal {
    nvim C:\Users\Hugo\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
}

Set-Alias -Name et -Value edit-terminal

function touch { New-Item -ItemType File -Path $args[0] | Out-Null }

function ff($name) {
    Get-ChildItem -Recurse -Filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Output "$($_.FullName)"
    }
}

# Network Utilities
function Get-PubIP { (Invoke-WebRequest http://ifconfig.me/ip).Content }

# Admin Check and Prompt Customization
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
function prompt {
    if ($isAdmin) { "[" + (Get-Location) + "] # " } else { "[" + (Get-Location) + "] $ " }
}

# Open WinUtil full-release
function winutil {
    Invoke-RestMethod https://christitus.com/win | Invoke-Expression
}

# Open WinUtil pre-release
function winutildev {
    Invoke-RestMethod https://christitus.com/windev | Invoke-Expression
}

# System Utilities
function admin {
    if ($args.Count -gt 0) {
        $argList = $args -join ' '
        Start-Process wt -Verb runAs -ArgumentList "pwsh.exe -NoExit -Command $argList"
    }
    else {
        Start-Process wt -Verb runAs
    }
}

function unzip ($file) {
    Write-Output("Extracting", $file, "to", $pwd)
    $fullFile = Get-ChildItem -Path $pwd -Filter $file | ForEach-Object { $_.FullName }
    Expand-Archive -Path $fullFile -DestinationPath $pwd
}

# $adminSuffix = if ($isAdmin) { " [ADMIN]" } else { "" }
# $Host.UI.RawUI.WindowTitle = "PowerShell {0}$adminSuffix" -f $PSVersionTable.PSVersion.ToString()

function pathAdd {
    param(
        [Parameter(Mandatory)]
        [string]$PathToAdd
    )

    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $paths = $userPath -split ';'

    if ($paths -contains $PathToAdd) {
        Write-Host "Already exists in PATH: $PathToAdd"
        return
    }

    [Environment]::SetEnvironmentVariable(
        "Path",
        ($paths + $PathToAdd) -join ';',
        "User"
    )

    $env:Path += ";$PathToAdd"

    Write-Host "Added to User PATH: $PathToAdd"
}

function pathClean {
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")

    $paths = $userPath -split ';'

    $cleanPath = (
        $paths |
            Where-Object { $_ -and (Test-Path $_) } |
            Select-Object -Unique
    )

    $removed = $paths | Where-Object { $_ -and $_ -notin $cleanPath }

    if ($removed) {
        Write-Host "Removing:"
        $removed | ForEach-Object { Write-Host "  $_" }
    }
    else {
        Write-Host "No invalid paths found"
    }

    $cleanPath = $cleanPath -join ';'

    [Environment]::SetEnvironmentVariable("Path", $cleanPath, "User")
    $env:Path = $cleanPath

    Write-Host "PATH cleaned"
}

function sshstart {
    $keyPath = "$env:USERPROFILE\.ssh\id_ed25519"

    # Start ssh-agent silently if not running
    if (-not (Get-Service ssh-agent -ErrorAction SilentlyContinue).Status -eq 'Running') {
        Start-Service ssh-agent | Out-Null
    }

    # Add key only if it's not already loaded
    if (-not (ssh-add -l 2>&1 | Select-String ([regex]::Escape($keyPath)))) {
        ssh-add $keyPath | Out-Null
    }
}


# git remote add origin
function grao {
    param (
        [Parameter(Mandatory = $true)]
        [string]$branchName,
        [Parameter(Mandatory = $true)]
        [string]$repoUrl
    )

    # Convert HTTPS to SSH format
    $sshUrl = $repoUrl -replace '^https://github.com/', 'git@github.com:'

    git remote add origin $sshUrl
    git branch -M $branchName
    git push -u origin $branchName
}

function eclip { es $args | fzf | clip }

function ez {
    $path = es $args | fzf

    if (-not $path) { return }

    if (Test-Path $path -PathType Leaf) {
        $path = Split-Path $path -Parent
    }

    Set-Location $path
}

function ev {
    $selected = es $args | fzf
    if (-not $selected) { return }
    nvim "$selected"
}

function ex {
    $selected = es $args | fzf
    if (-not $selected) { return }

    if (Test-Path $selected -PathType Container) {
        __zoxide_z "$selected"
    } 
}

Set-Alias v -Value nvim
Set-Alias vim -Value nvim

function nvimconfig { Set-Location "C:\Users\Hugo\AppData\Local\nvim\" }

function nvimundo { 
    $undoDir = "C:/Users/Hugo/AppData/Local/nvim-data/undo"
    $daysThreshold = 60 * 12

    Get-ChildItem -Path $undoDir -File | Where-Object {
        $_.LastWriteTime -lt (Get-Date).AddDays(-$daysThreshold)
    } | Remove-Item -Force
    Write-Output "Removed undo files older than $daysThreshold days"
}

function nvimclean {
    if (Get-Process -Name "nvim" -ErrorAction SilentlyContinue) {
        Write-Host "Neovim is running."
    }
    else {
        Remove-Item C:\Users\Hugo\AppData\Local\nvim-data\shada\main.shada.tmp.* 
        Write-Output "Shada files deleted"
        Remove-Item C:\Users\Hugo\AppData\Local\nvim-data\swap\*.*
        Write-Output "Swap files deleted"
        nvimundo
    }
}

function restartKanata {
    & "D:\Users\Hugo\Documents\Scripts\Restart Kanata.bat"
}

function getInstalledFonts { Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" }

# Remove-Item Alias:find -Force -ErrorAction SilentlyContinue
# Set-Alias find -Value "/usr/bin/find"

# Set-Alias nvim -Value "C:\Program Files\Neovide\neovide.exe"

Remove-Item Alias:ps -Force -ErrorAction SilentlyContinue

function ps { Get-Process *$args* }

function pkill {
    Get-Process $args -ErrorAction SilentlyContinue | Stop-Process
}

Set-Alias pk -Value pkill

function sed($file, $find, $replace) {
    (Get-Content $file).replace("$find", $replace) | Set-Content $file
}

function which {
    Get-Command $args | Select-Object -ExpandProperty Definition
}

# Directory Management
function mkcd { param($dir) mkdir $dir -Force; Set-Location $dir }

function tr { Remove-ItemSafely($args) }

Set-Alias trash -Value tr

function ddu { Invoke-Item "C:\ProgramData\chocolatey\bin\Display Driver Uninstaller.exe" }

function chococlean { & "C:\Aplications\BCURRAN3\Choco Outdated.bat" }

Remove-Item Alias:ls -ErrorAction SilentlyContinue

function ls($params) { Get-ChildItem $params | Format-Wide -Column 4 }


function dnsChange {
    param(
        [Parameter(Mandatory)]
        [string]$params
    )
    Set-DnsClientServerAddress -InterfaceAlias "Wi-Fi" -ServerAddresses ($params -split ",\s*")
}

# Register Argument Completer outside the function
Register-ArgumentCompleter -CommandName dnsChange -ParameterName params -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    
    $dnsOptions = @(
        '"1.1.1.1, 1.0.0.1"',
        '"8.8.8.8, 8.0.0.8"',
        '"208.67.222.222, 208.67.220.220"',
        '"189.38.95.95, 189.38.95.96"'
    )

    # Filter suggestions based on the word the user typed so far
    $dnsOptions | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}



# # Move up a directory with u or multiple with u{number}
function u { Set-Location .. }
# for($i = 1; $i -le 5; $i++){
# $u =  "".PadLeft($i,"u")
# $unum =  "u$i"
# $d =  $u.Replace("u","../")
# Invoke-Expression "function $u { push-location $d }"
# Invoke-Expression "function $unum { push-location $d }"
# }

# Restart Process
function pres {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    $process = Get-CimInstance Win32_Process -Filter "Name = '$Name'" | Select-Object -First 1

    if (-not $process) {
        Write-Error "Process '$Name' not found."
        return
    }

    $exePath = $process.ExecutablePath
    if (-not $exePath) {
        Write-Error "Unable to determine executable path for '$Name'."
        return
    }

    try {
        Stop-Process -Id $process.ProcessId -Force -ErrorAction Stop
        Start-Process $exePath
        Write-Host "Restarted process '$Name' from '$exePath'."
    }
    catch {
        Write-Error "Failed to restart process '$Name': $_"
    }
}

# Slower grep if needed
function rep {
    param([string]$Pattern)
    process {
        $_ | findstr /I $Pattern
    }
}

function suspend {
    # load assembly System.Windows.Forms which will be used
    Add-Type -AssemblyName System.Windows.Forms

    # set powerstate to suspend (sleep mode)
    $PowerState = [System.Windows.Forms.PowerState]::Suspend;

    # do not force putting Windows to sleep
    $Force = $false;

    # so you can wake up your computer from sleep
    $DisableWake = $false;

    # do it! Set computer to sleep
    [System.Windows.Forms.Application]::SetSuspendState($PowerState, $Force, $DisableWake);
}

function bios { shutdown /t 0 /r /fw }

function Clear-Cache {
    # add clear cache logic here
    Write-Host "Clearing cache..." -ForegroundColor Cyan

    # Clear Windows Prefetch
    Write-Host "Clearing Windows Prefetch..." -ForegroundColor Yellow
    Remove-Item -Path "$env:SystemRoot\Prefetch\*" -Force -ErrorAction SilentlyContinue

    # Clear Windows Temp
    Write-Host "Clearing Windows Temp..." -ForegroundColor Yellow
    Remove-Item -Path "$env:SystemRoot\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

    # Clear User Temp
    Write-Host "Clearing User Temp..." -ForegroundColor Yellow
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

    # Clear Internet Explorer Cache
    Write-Host "Clearing Internet Explorer Cache..." -ForegroundColor Yellow
    Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\*" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "Cache clearing completed." -ForegroundColor Green
}

Register-ArgumentCompleter -CommandName changeTheme -ParameterName name -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    Get-ChildItem -Path 'C:\Program Files (x86)\oh-my-posh\themes' -Filter *.omp.json |
        ForEach-Object { $_.BaseName -replace '\.omp$', '' } |
        Where-Object { $_ -like "$wordToComplete*" } |
        ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

function Reset-Profile {
    & $PROFILE.CurrentUserAllHosts
}

function changeTheme {
    param (
        [Parameter(Mandatory)]
        [string]$name
    )

    $filePath = "D:\Users\Hugo\Documents\System_Documents\PowerShell\profile.ps1"
    $searchPattern = "poshTheme = 'C:\\Program Files \(x86\)\\oh-my-posh\\themes\\[a-zA-Z0-9].*\.omp\.json'"
    $replaceText = "poshTheme = 'C:\Program Files (x86)\oh-my-posh\themes\$name.omp.json'"
    (Get-Content -Path $filePath) -replace $searchPattern, $replaceText | Set-Content -Path $filePath

    Invoke-Expression "oh-my-posh init pwsh --config='C:\Program Files (x86)\oh-my-posh\themes\$name.omp.json' | Invoke-Expression"
    Invoke-Expression "Reset-Profile"
}

$poshTheme = 'C:\Program Files (x86)\oh-my-posh\themes\amro.omp.json'

Invoke-Expression "oh-my-posh init pwsh --config='$poshTheme' | Invoke-Expression"

$Host.UI.RawUI.WindowTitle = $env:WT_MODE

# if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
#   Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -SkipPublisherCheck
# }

$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

$null = Register-EngineEvent -SourceIdentifier 'PowerShell.OnIdle' -MaxTriggerCount 1 -Action {
    # Import Modules and External Profiles
    # Ensure Terminal-Icons module is installed before importing

    Import-Module -Name Terminal-Icons

    # Enhanced PowerShell Experience
    # Enhanced PSReadLine Configuration
    $PSReadLineOptions = @{
        EditMode                      = 'Windows'
        HistoryNoDuplicates           = $true
        HistorySearchCursorMovesToEnd = $true
        Colors                        = @{
            Command   = '#87CEEB'  # SkyBlue (pastel)
            Parameter = '#98FB98'  # PaleGreen (pastel)
            Operator  = '#FFB6C1'  # LightPink (pastel)
            Variable  = '#DDA0DD'  # Plum (pastel)
            String    = '#FFDAB9'  # PeachPuff (pastel)
            Number    = '#B0E0E6'  # PowderBlue (pastel)
            Type      = '#F0E68C'  # Khaki (pastel)
            Comment   = '#D3D3D3'  # LightGray (pastel)
            Keyword   = '#8367c7'  # Violet (pastel)
            Error     = '#FF6347'  # Tomato (keeping it close to red for visibility)
        }
        PredictionSource              = 'History'
        PredictionViewStyle           = 'ListView'
        BellStyle                     = 'None'
    }
    Set-PSReadLineOption @PSReadLineOptions

    # Custom functions for PSReadLine
    Set-PSReadLineOption -AddToHistoryHandler {
        param($line)
        $sensitive = @('password', 'secret', 'token', 'apikey', 'connectionstring')
        $hasSensitive = $sensitive | Where-Object { $line -match $_ }
        return ($null -eq $hasSensitive)

    }

    # Improved prediction settings
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    Set-PSReadLineOption -MaximumHistoryCount 10000

    # Custom key handlers
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key "Ctrl+p" -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Key "Ctrl+n" -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
    Set-PSReadLineKeyHandler -Chord 'Ctrl+w' -Function BackwardDeleteWord
    Set-PSReadLineKeyHandler -Chord 'Alt+d' -Function DeleteWord
    Set-PSReadLineKeyHandler -Chord 'Ctrl+LeftArrow' -Function BackwardWord
    Set-PSReadLineKeyHandler -Chord 'Ctrl+RightArrow' -Function ForwardWord
    Set-PSReadLineKeyHandler -Chord 'Ctrl+z' -Function Undo
    Set-PSReadLineKeyHandler -Chord 'Ctrl+y' -Function Redo
}

Set-Alias -Name z -Value __zoxide_z -Option AllScope -Scope Global -Force
Set-Alias -Name zi -Value __zoxide_zi -Option AllScope -Scope Global -Force
Invoke-Expression (& { (zoxide init powershell | Out-String) })
function zz { z - }
