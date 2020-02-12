function run-apps{
param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$DeviceName=''
)

    If ([string]::IsNullOrEmpty($Subscription ))
    {
        write-Host ''
        $prompt =  'Need to select a Subscription first.'
        get-anykey $prompt
        return
    }
    elseIf ([string]::IsNullOrEmpty($GroupName ))
    {
        write-Host ''
        $prompt = 'Need to select a Group first.'
        get-anykey $prompt
        return
    }
    elseIf ([string]::IsNullOrEmpty($HubName ))
    {
        write-Host ''
        prompt =  'Need to select a Hub first.'
        get-anykey $prompt
        return
    }
        elseIf ([string]::IsNullOrEmpty($DeviceName ))
    {
        write-Host ''
        prompt =  'Need to select a Device first.'
        get-anykey $prompt
        return
    }

    try {
        . ("$global:ScriptDirectory\util\set-envvar.ps1")
        . ("$global:ScriptDirectory\util\set-export.ps1")
    }
    catch {
        Write-Host "Error while loading supporting PowerShell Scripts" 
        Write-Host $_
    }


        util\heading '  R U N   Q U I K S T A R T  I O T   H U B  A P P S   '  -BG DarkBlue   -FG White
        $Prompt = '   Subscription :"' + $Subscription +'"'
        write-Host $Prompt
        $Prompt = '          Group :"' + $GroupName +'"'
        write-Host $Prompt
        $Prompt = '            Hub :"' + $HubName +'"'
        write-Host $Prompt
        $Prompt = ' Current Device :"' + $DeviceName +'"'
        write-Host $Prompt

        show-quickstarts "Quickstart/s to run"
    
        util\heading '  R U N   Q U I K S T A R T  I O T   H U B  A P P S   '  -BG DarkBlue   -FG White
    
        $answer = $global:retVal
        if ($answer -eq 'Back')
        {
            return $answer
        }
             
        $PsScriptFile = $answer
 


        Write-Host "Setting location to $PsScriptFile."
        write-Host "There are a device and a service app to run."
        write-Host 'Enter ' -nonewline 
        write-host '.\run-apps' -nonewline   -BackgroundColor Blue -ForegroundColor White
        write-host ' to run the apps simultaneously.'
        write-Host 'Assumes that Environment Variables have been set.'  -BackgroundColor DarkRed -ForegroundColor White
        write-host 'To just run the device cd to  it then '  -nonewline  
        write-host 'dotnet run' -BackgroundColor Blue -ForegroundColor White
        Set-Location -Path  $PsScriptFile
        get-childitem -Directory | select-object name
        return 'Exit'   
}