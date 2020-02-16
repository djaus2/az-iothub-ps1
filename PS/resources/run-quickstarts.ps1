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
        . ("$global:ScriptDirectory\util\get-dncore.ps1")
        . ("$global:ScriptDirectory\util\get-dncore-existing.ps1")
    }
    catch {
        Write-Host "Error while loading supporting PowerShell Scripts" 
        Write-Host $_
    }

    do{
        util\heading '  R U N   Q U I K S T A R T  I O T   H U B  A P P S   '  -BG DarkBlue   -FG White
        $Prompt = '   Subscription :"' + $Subscription +'"'
        write-Host $Prompt
        $Prompt = '          Group :"' + $GroupName +'"'
        write-Host $Prompt
        $Prompt = '            Hub :"' + $HubName +'"'
        write-Host $Prompt
        $Prompt = ' Current Device :"' + $DeviceName +'"'
        write-Host $Prompt


            $itemsList ='Run App/s,Clear App Builds,Set .NET Core,Get .NET Core,Using Existing .NET Core'

        
            choose-selection $itemsList  'Quickstarts Action'   '' ','
            $answer = $global:retVal1
            if ( $global:retVal -eq 'Back'){
                return  'Back'
            }

            switch ($answer)
            {
                'D1'    {  $done = $true }
                'D2'    {  $response = Clr-Apps $Subscription $GroupName $HubName $DeviceName }
                'D3'    { 
                    $dnp ="$global:ScriptDirectory\quickstarts\dotnet"
                    $addPath=$dnp
                    if (Test-Path $addPath){
                        New-Item -ItemType Directory -Force -Path $addPath
                    }                    
                    if (Test-Path $addPath){
                        $regexAddPath = [regex]::Escape($addPath)
                        $arrPath = $env:Path -split ';' | Where-Object {$_ -notMatch "^$regexAddPath\\?"}
                        $env:Path = ($arrPath + $addPath) -join ';'
                        $env:DOT_NET_ROOT = $dnp 
                    } else {
                        Throw "'$addPath' is not a valid path."
                    }
                 }
                'D4'    {  get-dotnetcore }
                'D5'    {  get-existingdotnetcore }
                'D6'    {  return 'Back' }
            }  
        } while (-not $done)

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