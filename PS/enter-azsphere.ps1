# C:\Windows\System32\cmd.exe /k "C:\Program Files (x86)\Microsoft Azure Sphere SDK\\InitializeCommandPrompt.cmd
#
# InitializeCommandPrompt.cmd:
# ============================
# @REM Set up a Developer Command Prompt for Azure Sphere tools.
# @cls
# @PATH=%~dp0;%~dp0\Tools;%PATH%
# @REM Query the Sysroot registry for list sysroots.  Add the latest sysroot to the PATH.
# @for /F "tokens=1,2*" %%A IN ('REG.EXE QUERY "HKLM\SOFTWARE\Microsoft\Azure Sphere\Sysroots" /reg:32 /s /v InstallDir') do @if '%%A'=='InstallDir' set Sysroot=%%C
# @PATH=%sysroot%\tools\gcc;%PATH%

function enter-azSphere{
    $env:dp0="$env:ProgramFiles (x86)\Microsoft Azure Sphere SDK"
    $env:sysroots="$env:dp0\sysroots"
    $env:latestgcc="4+Beta2001"
    $dirs = Get-ChildItem  -Directory -path $env:sysroots  | select-object name|  out-string
    $dirsList= $dirs -split '\n' | Sort-Object -Descending
    write-host "Using gcc version $env:latestgcc"
    write-host "Available versions:"
    $n=0;
    foreach ($i in $dirsList)
    {
        $i=$i.trim()
        $n++
        if ($n -eq 1)
        {
            continue
        }
        elseif($i -eq '')
        {
            continue
        }
        elseif ($i -eq "----")
        {
            continue
        }
        $i
    }
    get-yesorno $true "Is that OK?"
    function add-path
    {
        param (
        [string]$addPath=''
        )
    
        if (Test-Path $addPath){
            $regexAddPath = [regex]::Escape($addPath)
            $arrPath = $env:Path -split ';' | Where-Object {$_ -notMatch "^$regexAddPath\\?"}
            $env:Path = ($arrPath + $addPath) -join ';'
            
        } else {
            Throw "'$addPath' is not a valid path."
        }
    }
    

    add-path $env:dp0
    add-path "$env:dp0\tools"
    $env:sysroots="$env:sysroots\$env:latestgcc"
    add-path "$env:sysroots\tools\gcc"
    If  ([string]::IsNullOrEmpty($env:IsRedirected))
    {
        $env:Path -split ';'
    }
}
$global:ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. ("$global:ScriptDirectory\menu\yes-no-menu.ps1")
enter-azsphere