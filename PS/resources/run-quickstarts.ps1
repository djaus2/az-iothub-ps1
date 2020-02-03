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


        util\heading '  R U N   Q U I K S T A R T  I O T   H U B  A P P S   '  -BG DarkGreen   -FG White
        $Prompt = '   Subscription :"' + $Subscription +'"'
        write-Host $Prompt
        $Prompt = '          Group :"' + $GroupName +'"'
        write-Host $Prompt
        $Prompt = '            Hub :"' + $HubName +'"'
        write-Host $Prompt
        $Prompt = ' Current Device :"' + $DeviceName +'"'
        write-Host $Prompt

        $itemsList ='Generate Environment Variables,Clear Env Vars,Write Env Vars To File,Set Bash Env Vars,Generate Bash Envs,Write Bash Env Vars to File,Done'
        $lst = Get-ChildItem $global:ScriptDirectory\Quickstarts  | ?{ $_.PSIsContainer } | Select-Object Name | convertto-csv -NoTypeInformation
        $list2 = $lst -split '\n'
        $menu = $list2 | ? {$_.Trim()} | Select-Object -Skip 1
        [string]$itemslist =''
        foreach ($app in $menu) 
        {
            $app2 = $app  -replace '"',''
            if ($app2 -ne 'Common')
            {
                $itemslist += $app2 + ','
            }
        }
        $itemslist = $itemslist.Substring(0, $itemslist.Length-1)
        write-host $itemsList
        

        

        choose-selection $itemslist  'Quickstarts'  ''  ','
        $answer = $global:retVal
        if ($answer -eq 'Back')
        {
            return $answer
        }
        write-Host 'Enter .\run-apps run to run the apps simultaneously.'
        write-Host 'Assumes that you have written env vars an run script to these apps.'
        Set-Location -Path $global:ScriptDirectory\Quickstarts\$answer
        return 'Exit'   
}