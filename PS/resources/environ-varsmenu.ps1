function Do-Envs{
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

    do {
        util\heading '  S E T  E N V I R O N M E N T  V A R S   '  -BG DarkBlue   -FG White
        $Prompt = '   Subscription :"' + $Subscription +'"'
        write-Host $Prompt
        $Prompt = '          Group :"' + $GroupName +'"'
        write-Host $Prompt
        $Prompt = '            Hub :"' + $HubName +'"'
        write-Host $Prompt
        $Prompt = ' Current Device :"' + $DeviceName +'"'
        write-Host $Prompt

        $itemsList ='Show Environment Variables,Generate Env Vars,Clear Env Vars,Write Env Vars To File,Read Env Vars from File,Set Bash Env Vars,Generate Bash Envs,Write Bash Env Vars to File,Done'


        choose-selection $itemsList  'Action for IoT Hub Connection String Environment Variables'   '' ','
        $answer = $global:retVal1
        
        if ( $global:retVal -eq 'Back'){
            return  'Back'
        }

        switch ($answer)
        {
            'D1'    {  show-env $Subscription $GroupName $HubName $DeviceName }
            'D2'    {  set-env $Subscription $GroupName $HubName $DeviceName }
            'D3'    {  clear-env  }
            'D4'    {  write-env $Subscription $GroupName $HubName $DeviceName  }
            'D5'    {  read-env $Subscription $GroupName $HubName $DeviceName  }
            'D6'    {  set-export $Subscription $GroupName $HubName $DeviceName }
            'D7'    {  clear-export $Subscription $GroupName $HubName $DeviceName }
            'D8'    {  write-export $Subscription $GroupName $HubName $DeviceName }
            'D9'    {  return 'Back' }
        }  
    }  
    while ($true)
    
}