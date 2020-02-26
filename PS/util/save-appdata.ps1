function Save-AppData{

    show-heading '  S A V E   A P P   D A T A  '  2
    
    write-Host 'This saves current Subscription,Group,Hub and Device names, as well as Azure queries for listing of Subscription Groups, Hub etc. Also can get .NET Core'

    $PsScriptFile =  "$global:ScriptDirectory\app-settings.ps1"

    $prompt ='# get-iothub.ps1 app data' 
    write-Host $prompt
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
        $prompt = 'SpecificVersion =  "' + "$global:SpecificVersion" +'"'
        write-Host $prompt
        Add-Content -Path  $PsScriptFile   -Value $prompt
    }
    else
    {
        $prompt = 'SpecificVersion =  "' + "3.1.102" +'"'
        write-Host $prompt
        Add-Content -Path  $PsScriptFile   -Value $prompt
    }


    
    write-host 'Written app data as  ps script to script root as app-settings.ps1'
    write-host "Written to : $PsScriptFile"
    get-anykey
        
}