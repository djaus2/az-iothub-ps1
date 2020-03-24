function Do-Envs{
param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$DeviceName=''
)

    try{
    . ("$global:ScriptDirectory\util\set-envvar.ps1")
    . ("$global:ScriptDirectory\util\write-env.ps1")
    . ("$global:ScriptDirectory\util\set-export.ps1")
    . ("$global:ScriptDirectory\util\write-export.ps1")
    . ("$global:ScriptDirectory\util\write-json.ps1")
    } catch {
        Write-Host "Error while loading supporting Env Vars PowerShell Scripts" 
        Write-Host $_
    }


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
        . ("$global:ScriptDirectory\util\set-json.ps1")
        . ("$global:ScriptDirectory\menu\select-subfolder.ps1")
    }
    catch {
        Write-Host "Error while loading supporting PowerShell Scripts" 
        Write-Host $_
    }

    do {
        show-heading '  S E T  E N V I R O N M E N T  V A R S   ' 2
        $Prompt = '   Subscription :"' + $Subscription +'"'
        write-Host $Prompt
        $Prompt = '          Group :"' + $GroupName +'"'
        write-Host $Prompt
        $Prompt = '            Hub :"' + $HubName +'"'
        write-Host $Prompt
        $Prompt = ' Current Device :"' + $DeviceName +'"'
        write-Host $Prompt

        # $itemsList ='Show Environment Variables,Generate Env Vars,Permanently set Env Vars,Clear Env Vars,Read Env Vars from File,Set Bash Env Vars,Generate Bash Envs,Write Env Vars To set-env.ps1 File,Write Bash Env Vars to set-env.sh File,Write Env Vars To launchSettings.Json'
        $itemsList ='Show Environment Variables,Generate Env Vars,Permanently set Env Vars,Clear Env Vars,Read Env Vars from File,Write Env Vars To set-env.ps1 File,Write Bash Env Vars to set-env.sh File,Write Env Vars To launchSettings.Json'


        choose-selection $itemsList  'Action for IoT Hub Connection String Environment Variables'   '' ','
        $answer = $global:retVal1
        
        if ( $global:retVal -eq 'Back'){
            return  'Back'
        }

        if ($false){
            # 'D6'    {  set-export $Subscription $GroupName $HubName $DeviceName }
            # 'D7'    {  clear-export $Subscription $GroupName $HubName $DeviceName }
            #'D8'    {  write-env $Subscription $GroupName $HubName $DeviceName  }
           # 'D9'    {  write-export $Subscription $GroupName $HubName $DeviceName }
           # 'D0'    {  write-json $Subscription $GroupName $HubName $DeviceName }
            }

        switch ($answer)
        {
            'D1'    {  show-env $Subscription $GroupName $HubName $DeviceName }
            'D2'    {  set-env $Subscription $GroupName $HubName $DeviceName }
            'D3'    {  set-permanent $Subscription $GroupName $HubName $DeviceName }
            'D4'    {  clear-env  }
            'D5'    {  read-env $Subscription $GroupName $HubName $DeviceName  }

            'D6'    {  write-env $Subscription $GroupName $HubName $DeviceName  }
            'D7'    {  write-export $Subscription $GroupName $HubName $DeviceName }
            'D8'    {  write-json $Subscription $GroupName $HubName $DeviceName }
            

            
            
        }  
    }  
    while ($true)
    
}