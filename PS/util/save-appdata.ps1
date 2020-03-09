function Save-AppData{

    show-heading '  S A V E   A P P   D A T A  '  2
    
    write-Host 'This saves current Subscription,Group,Hub and Device names, as well as Azure queries for listing of Subscription Groups, Hub etc. Also can get .NET Core'

    $PsScriptFile =  "$global:ScriptDirectory\app-settings.ps1"

    $prompt ="Writing app data (The Subscription name, Group name etc their Az queries) to $PsScriptFile"
    get-anykey $prompt, 'Continue'

    Out-File -FilePath $PsScriptFile    -InputObject $prompt -Encoding ASCII
    

    If (-not([string]::IsNullOrEmpty($global:Subscription )))
    {
        $prompt = '$global:Subscription =  "' + "$global:Subscription" +'"'
        write-Host $prompt
        Add-Content -Path  $PsScriptFile   -Value $prompt
    }

    If (-not([string]::IsNullOrEmpty($global:GroupName )))
    {
        $prompt = '$global:GroupName =  "' + "$global:GroupName" +'"'
        write-Host $prompt
        Add-Content -Path  $PsScriptFile   -Value $prompt
    }


    If (-not([string]::IsNullOrEmpty($global:HubName )))
    {
        $prompt = '$global:HubName =  "' + "$global:HubName" +'"'
        write-Host $prompt
        Add-Content -Path  $PsScriptFile   -Value $prompt
    }
    
    If (-not([string]::IsNullOrEmpty($global:DeviceName )))
    {
        $prompt = '$global:DeviceName =  "' + "$global:DeviceName" +'"'
        write-Host $prompt
        Add-Content -Path  $PsScriptFile   -Value $prompt
    }

    If (-not([string]::IsNullOrEmpty($global:SubscriptionsStrn )))
    {
        $prompt = '$global:SubscriptionsStrn =  "' + "$global:SubscriptionsStrn" +'"'
        write-Host $prompt
        Add-Content -Path  $PsScriptFile   -Value $prompt
    }

    If (-not([string]::IsNullOrEmpty($global:GroupsStrn )))
    {
        $prompt = '$global:GroupsStrn =  "' + "$global:GroupsStrn" +'"'
        write-Host $prompt
        Add-Content -Path  $PsScriptFile   -Value $prompt
    }


    If (-not([string]::IsNullOrEmpty($global:HubsStrn )))
    {
        $prompt = '$global:HubsStrn =  "' + "$global:HubsStrn" +'"'
        write-Host $prompt
        Add-Content -Path  $PsScriptFile   -Value $prompt
    }
    
    If (-not([string]::IsNullOrEmpty($global:DevicesStrn )))
    {
        $prompt = '$global:DevicesStrn =  "' + "$global:DevicesStrn" +'"'
        write-Host $prompt
        Add-Content -Path  $PsScriptFile   -Value $prompt
    }

    If (-not([string]::IsNullOrEmpty($global:SpecificVersion )))
    {
        $prompt = '$global:SpecificVersion =  "' + "$global:SpecificVersion" +'"'
        write-Host $prompt
        Add-Content -Path  $PsScriptFile   -Value $prompt
    }
    else
    {
        $prompt = '$global:SpecificVersion =  "' + "3.1.102" +'"'
        write-Host $prompt
        Add-Content -Path  $PsScriptFile   -Value $prompt
    }


    
    write-host 'Written app data as  ps script to script root as app-settings.ps1'
    write-host "Written to : $PsScriptFile"
    get-anykey
        
}

function clear-appData
{ 
    show-heading  -Prompt '  C L E A R   A P P   V A L U E S  ' 2
    get-yesorno $false 'Clear script globals variables? [Yes] [No]'
    $answer = $global:retVal
    if ($answer)
    {
        
        If (-not([string]::IsNullOrEmpty($global:Subscription )))
        {
            remove-variable Subscription -Scope Global
        }

    
        If (-not([string]::IsNullOrEmpty($global:GroupName )))
        {
            remove-variable GroupName   -Scope Global
        }
    
        If (-not([string]::IsNullOrEmpty($global:HubName )))
        {
            remove-variable HubName  -Scope Global
        }
        
        If (-not([string]::IsNullOrEmpty($global:DeviceName )))
        {
            remove-variable DeviceName  -Scope Global
        }
    
        If (-not([string]::IsNullOrEmpty($global:SubscriptionsStrn )))
        {
            remove-variable SubscriptionsStrn  -Scope Global
        }
    
        If (-not([string]::IsNullOrEmpty($global:GroupsStrn )))
        {
            remove-variable GroupsStrn  -Scope Global
        }
    
    
        If (-not([string]::IsNullOrEmpty($global:HubsStrn )))
        {
            remove-variable HubsStrn  -Scope Global
        }
        
        If (-not([string]::IsNullOrEmpty($global:DevicesStrn )))
        {
            remove-variable DevicesStrn  -Scope Global
        }
    
        If (-not([string]::IsNullOrEmpty($global:SpecificVersion )))
        {
            remove-variable SpecificVersion  -Scope Global
        }
        If (-not([string]::IsNullOrEmpty($global:retVal )))
        {
            remove-variable retVal  -Scope Global
        }
        If (-not([string]::IsNullOrEmpty($global:retVal1 )))
        {
            remove-variable retVal1  -Scope Global
        }
        If (-not([string]::IsNullOrEmpty($global:retVal2 )))
        {
            remove-variable retVal2  -Scope Global
        }

        If (-not([string]::IsNullOrEmpty($global:yesnowait )))
        {
            remove-variable yesnowait  -Scope Global
        }

        If (-not([string]::IsNullOrEmpty($global:Location )))
        {
            remove-variable Location  -Scope Global
        }

        If (-not([string]::IsNullOrEmpty($global:SKU )))
        {
            remove-variable SKU  -Scope Global
        }

        If (-not([string]::IsNullOrEmpty($global:LogAzIoTPS )))
        {
            remove-variable LogAzIoTPS  -Scope Global
        }

        
        $PsScriptFile = "$global:ScriptDirectory\app-settings.ps1"
        Remove-Item  $PsScriptFile 


    }
}
