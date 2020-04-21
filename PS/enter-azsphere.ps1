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
    
    # Nb: Change this if different. The cmd looks for it in registry. 
    # I found it is not in registry. Seems to just use the location of that script
    $env:dp0="C:\ProgramFiles (x86)\Microsoft Azure Sphere SDK"

    $env:sysroots="$env:dp0\sysroots"
    $dirs = Get-ChildItem  -Directory -path $env:sysroots  | select-object name|  out-string
    $dirsList= $dirs -split '\n' | Sort-Object -Descending
    $SelectionList1 =@()
    $SelectionList = {$SelectionList1}.Invoke()
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
        $SelectionList.Add($i)    > $null   
    }
    # Select the first value.
    $env:latestgcc=$SelectionList[0]

    write-host "Using gcc version $env:latestgcc"
    write-host ''
    write-host "Available versions:"
    write-host "-------------------"
    $n=0;
    foreach ($i in $SelectionList)
    {
        $i
    }
    get-yesorno $true " Is that OK?"

    if (-not $global:retVal){
        write-Host 'Set  $env:latestgcc in script to desired fixed value. Line 57'
    } else {


        add-path $env:dp0
        add-path "$env:dp0\tools"
        $env:sysroots="$env:sysroots\$env:latestgcc"
        add-path "$env:sysroots\tools\gcc"
        If  ([string]::IsNullOrEmpty($env:IsRedirected))
        {
            $env:Path -split ';'
        }
    }
}

# show-heading calls this. Make a dummy call here:
function show-time{}# Uses this this script

# Entry point if run alone:
# ==============================
$global:ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
# Uses thes two scripts
. ("$global:ScriptDirectory\util\show-heading.ps1")
. ("$global:ScriptDirectory\menu\yes-no-menu.ps1")
$headingfgColor_1="Black"
$headingbgColor_1="Green"
show-heading  -Prompt '  A Z U R E  S P H E R E Prompt  ' 1

# Run the script now
enter-azsphere