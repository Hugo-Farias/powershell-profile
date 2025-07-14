$Env:YAZI_FILE_ONE = "C:\Program Files\Git\usr\bin\file.exe"
$Env:YAZI_FILE_HOME = "C:\Users\Hugo\AppData\Roaming\yazi\config"

# $Env:KOMOREBI_CONFIG_HOME = 'C:\Users\Hugo\.config\komorebi'


Remove-Item Alias:sl -Force
Remove-Item Alias:gp -Force
Remove-Item Alias:diff -Force

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

function docu { Set-Location "D:\Users\Hugo\Documents" }

function desk { Set-Location "D:\Users\Hugo\Desktop" }

function pics { Set-Location "D:\Users\Hugo\Pictures" }

function musi { Set-Location "D:\Users\Hugo\Music" }

function vids { Set-Location "J:\Videos" }

function wttr { curl https://wttr.in/planaltina%20goias }

function wd { $pwd.Path }

Set-Alias v -Value nvim

function nvimconfig { nvim "C:\Users\Hugo\AppData\Local\nvim\init.lua" }
function nvimundo { 
  $undoDir = "C:/Users/Hugo/AppData/Local/nvim-data/undo"
  $daysThreshold = 30 * 6

  Get-ChildItem -Path $undoDir -File | Where-Object {
    $_.LastWriteTime -lt (Get-Date).AddDays(-$daysThreshold)
  } | Remove-Item -Force
  echo "Removed undo files older than $daysThreshold days"
}

function nvimclean {
  rm C:\Users\Hugo\AppData\Local\nvim-data\shada\main.shada.tmp.* 
  echo "Deleted Shada files"
  nvimundo
}

function getInstalledFonts { & Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" }

Set-Alias mic -Value micro

# Remove-Item Alias:find -Force
# Set-Alias find -Value "/usr/bin/find"

# Set-Alias nvim -Value "C:\Program Files\Neovide\neovide.exe"

Set-Alias ws -Value webstorm

function c { Set-Location -Path C:\ }
function d { Set-Location -Path D:\ }
function j { Set-Location -Path J:\ }
function k { Set-Location -Path K:\ }

Remove-Item Alias:ps -Force

function ps($name) { Get-Process *$name* }

function jet($name) { & "C:\Users\Hugo\AppData\Local\Programs\Webstorm 2\bin\ltedit.bat" -e $name }

function idea($name) { & "C:\Users\Hugo\AppData\Local\Programs\Webstorm 2\bin\webstorm64.exe" $name }

function tr($name) { Remove-ItemSafely($name) }

function ddu { ii "C:\ProgramData\chocolatey\bin\Display Driver Uninstaller.exe"}

function choco-outdated { & "C:\Aplications\BCURRAN3\Choco Outdated.bat"}

Remove-Item Alias:ls -Force
function ls($params) { Get-ChildItem $params | Format-Wide -Column 4 }

function changedns {
    param(
        [Parameter(Mandatory)]
        [string]$params
    )
    Set-DnsClientServerAddress -InterfaceAlias "Wi-Fi" -ServerAddresses ($params -split ",\s*")
}


# Register Argument Completer outside the function
Register-ArgumentCompleter -CommandName changedns -ParameterName params -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    
    $dnsOptions = @(
        '"1.1.1.1, 1.0.0.1"',
        '"8.8.8.8, 8.0.0.8"',
        '"208.67.222.222, 208.67.220.220"'
    )

    # Filter suggestions based on the word the user typed so far
    $dnsOptions | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

Set-Alias -Name showdns -Value Get-DnsClient 

Set-Alias -Name list -Value Get-ChildItem

Set-Alias -Name ll -Value Get-ChildItem

Set-Alias -Name htop -Value ntop

# # Move up a directory with u or multiple with u{number}
function u { cd .. }
# for($i = 1; $i -le 5; $i++){
  # $u =  "".PadLeft($i,"u")
  # $unum =  "u$i"
  # $d =  $u.Replace("u","../")
  # Invoke-Expression "function $u { push-location $d }"
  # Invoke-Expression "function $unum { push-location $d }"
# }

function restart {
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
    } catch {
        Write-Error "Failed to restart process '$Name': $_"
    }
}

Set-Alias -Name np -Value notepad++

#Set-Alias -Name npm -Value pnpm

#Set-Alias -Name rep -Value findstr

#function rep {findstr /I @args}

function rep {
    param([string]$Pattern)
    process {
        $_ | findstr /I $Pattern
    }
}

function zz { z - }

function Sleep-Computer {
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

function Bios-Computer {shutdown /t 0 /r /fw}

Register-ArgumentCompleter -CommandName Change-Theme -ParameterName name -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    Get-ChildItem -Path 'C:\Program Files (x86)\oh-my-posh\themes' -Filter *.omp.json |
        ForEach-Object { $_.BaseName -replace '\.omp$', '' } |
        Where-Object { $_ -like "$wordToComplete*" } |
        ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

function Change-Theme {
    param (
        [Parameter(Mandatory)]
        [string]$name
    )

    $filePath = "D:\Users\Hugo\Documents\System_Documents\PowerShell\profile.ps1"
    $searchPattern = "--config 'C:\\Program Files \(x86\)\\oh-my-posh\\themes\\[a-zA-Z0-9].*\.omp\.json'"
    $replaceText = "--config 'C:\Program Files (x86)\oh-my-posh\themes\$name.omp.json'"
    (Get-Content -Path $filePath) -replace $searchPattern, $replaceText | Set-Content -Path $filePath

    Invoke-Expression reload-profile
}

oh-my-posh init pwsh --config 'C:\Program Files (x86)\oh-my-posh\themes\amro.omp.json' | Invoke-Expression

### Invoke-Expression (& { (zoxide init powershell | Out-String)})
