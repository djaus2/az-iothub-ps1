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
        util\heading '  S E T  E N V I R O N M E N T  V A R S   '  -BG DarkGreen   -FG White
        $Prompt = '   Subscription :"' + $Subscription +'"'
        write-Host $Prompt
        $Prompt = '          Group :"' + $GroupName +'"'
        write-Host $Prompt
        $Prompt = '            Hub :"' + $HubName +'"'
        write-Host $Prompt
        $Prompt = ' Current Device :"' + $DeviceName +'"'
        write-Host $Prompt

        $selectionList =@('D1','D2','D3','D4','D5','D6','D7')
        $itemsList ='Generate Environment Variables,Clear Env Vars,Write Env Vars To File,Set Bash Env Vars,Generate Bash Envs,Write Bash Env Vars to File,Done'



        choose-selection $itemsList  'Hub Connwectyion Strins as Environment Variables' 
        $answer = $global:retVal1

        switch ($answer)
        {
            'D1'    {  set-env $Subscription $GroupName $HubName $DeviceName }
            'D2'    {  clear-env  }
            'D3'    {  write-env $Subscription $GroupName $HubName $DeviceName  }
            'D4'    {  set-export $Subscription $GroupName $HubName $DeviceName }
            'D5'    {  clear-export $Subscription $GroupName $HubName $DeviceName }
            'D6'    {  write-export $Subscription $GroupName $HubName $DeviceName }
            'D7'    {  return}
        }  
    }  
    while ($true)
    
}