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
       # . ("$global:ScriptDirectory\util\set-envvar.ps1")
        . ("$global:ScriptDirectory\util\set-export.ps1")
        . ("$global:ScriptDirectory\util\get-dncore.ps1")
        . ("$global:ScriptDirectory\util\get-dncore-existing.ps1")
        . ("$global:ScriptDirectory\menu\select-subfolder.ps1")
    }
    catch {
        Write-Host "Error while loading supporting PowerShell Scripts" 
        Write-Host $_
    }

    $done=$false
    $singleapp = $false
    do{
        show-heading '  R U N   Q U I K S T A R T  I o T   H U B  A P P S   '  2
        $Prompt = '   Subscription :"' + $Subscription +'"'
        write-Host $Prompt
        $Prompt = '          Group :"' + $GroupName +'"'
        write-Host $Prompt
        $Prompt = '            Hub :"' + $HubName +'"'
        write-Host $Prompt
        $Prompt = ' Current Device :"' + $DeviceName +'"'
        write-Host $Prompt


            $itemsList ='Run both the Device and Service apps simultaneously,Run one of the Device and Serice apps,Clear App Builds,Set .NET Core,Get .NET Core,Using Existing .NET Core,Set .NET Core Specific Version'

        
            choose-selection $itemsList  'Quickstarts Action'   '' ','
            $answer = $global:retVal1
            if ( $global:retVal -eq 'Back'){
                return  'Back'
            }

 
            switch ($answer)
            {
                'D1'    {  
                    $done = $true
                 }
                'D2'    {  
                    $done = $true 
                    $singleapp=$true
                }
                'D3'    {  $response = Clr-Apps $Subscription $GroupName $HubName $DeviceName }
                'D4'    { 
                    $dnp ="$global:ScriptDirectory\qs-apps\quickstarts\dotnet"
                    $addPath=$dnp
                    if (-not(Test-Path $addPath)){
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
                'D5'    {  get-dotnetcore }
                'D6'    {  get-existingdotnetcore }
                'D7'    { 
                    write-host "Enter .NET Core Version. (3.n.xyz) Currently: "
                    $SpecificVersion = read-host $global:SpecificVersion
                    If (-not ([string]::IsNullOrEmpty($SpecificVersion)) )
                    {
                        $SpecificVersion=$SpecificVersion
                    }
                }
                'D8'    {  return 'Back' }
            }  
        } while (-not $done)


        show-quickstarts "Quickstart/s to run"
    
        show-heading '  R U N   Q U I K S T A R T  I o T   H U B  A P P S   '  2
    
        $answer = $global:retVal
        if ($answer -eq 'Back')
        {
            return $answer
        }
             
        $PsScriptFile = $answer
        if ($singleapp)
        {
            select-subfolder $answer 'One app'
            $answer = $global:retVal
            if ($answer -eq 'Back')
            {
                return $answer
            }
            show-heading '  R U N  O N E  Q U I K S T A R T  I o T   H U B  A P P   '  2
            $PsScriptFile = $answer
            Write-Host "Setting location to $PsScriptFile."
            write-host ''
            write-Host "There is a device or service app to run: "  -nonewline 
            
            write-host  $global:retval1  -BackgroundColor Blue -ForegroundColor White
            write-host ''
            write-Host 'Enter ' -nonewline 
            write-host 'dotnet run'   -BackgroundColor Blue -ForegroundColor White  -nonewline 
            write-host ' to run the app.'
            write-host ''
            write-host '     ' -nonewline 
            write-host '  OR  ' -BackgroundColor Yellow -ForegroundColor Black
            write-host ''
            write-host 'dotnet publish --runtime linux-arm --framework 3.1 --self-contained true' -nonewline   -BackgroundColor Blue -ForegroundColor White
            write-host ' to build the app for transfer to a device.'
            write-host 'Change linux-arm to one of win-arm, win-x64, win-x86,linux-x64 etc.'
            write-host 'Change self contained to false if .NET Core 3.1 is installed on the device.'
            write-host 'On the device in this case enter: ' -nonewline
            write-host  "$global:retval1  ./$global:retval1  or .\$global:retval1"   -BackgroundColor Blue -ForegroundColor White  -nonewline 
            write-host ' depending upon the OS.'
            write-host ''
            write-Host 'Assumes that Environment Variables have been set.'  -BackgroundColor DarkRed -ForegroundColor White
            Set-Location -Path  $PsScriptFile
            return 'Exit'
        }
 


        Write-Host "Setting location to $PsScriptFile."
        write-host ''
        Write-Host "This is for the Quickstart pair of apps: " -nonewline 
        write-Host $global:retVal1  -BackgroundColor Blue -ForegroundColor White
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