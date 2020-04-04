function Get-DPS{
param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$Current = '',
    [boolean]$Refresh=$false
)

    If ([string]::IsNullOrEmpty($Subscription ))
    {
        write-Host ''
        $prompt =  'Need to select a Subscription first.'
        get-anykey $prompt
        $global:DPS =  'Back'
        return
    }
    elseIf ([string]::IsNullOrEmpty($GroupName ))
    {
        write-Host ''
        $prompt = 'Need to select a Group first.'
        get-anykey $prompt
        $global:DPS =  'Back'
        return
    }

    $Location =""
    If (-not [string]::IsNullOrEmpty($global:HubsStrn ))
    {
        try{
        $Location =  ($global:HubsStrn -split '\t')[2] 
        }
        catch {
            $Location = ''
        }
    }


    $DPSStrnIndex =3
    $DPSStrnDataIndex =5




    show-heading '  D E V I C E  P R O V I S I O N I N G  S E R V I C E (DPS)  '  2
    $Prompt = '   Subscription :"' + $Subscription +'"'
    write-Host $Prompt
    $Prompt = '          Group :"' + $GroupName +'"'
    write-Host $Prompt
    $Prompt = '            Hub :"' + $HubName +'"'
    write-Host $prompt
    $Prompt = '         Device :"' + $DeviceName +'"'
    write-Host $Prompt
    $Prompt = '    Current DPS :"' + $Current +'"'
    write-Host $Prompt


    if ($Refresh -eq $true)
    {
        $global:DPSStrn = null
    }
    elseif(-not([string]::IsNullOrEmpty($current)))
    {
        get-yesorno $True "Do you want to use the Current DPS? (Y/N)"
        $answer = $global:retVal
        if  ( $answer)
        {
            $global:retVal ='Back'
            return $current
        }
    }

    [boolean]$skip = $false
    if  ($global:DPSStrn -eq '')
    {
        # This allows for previously returned empty string
        $skip = $true
    }
    If  (([string]::IsNullOrEmpty($global:DPSStrn ))  -and (-not $skip))
    {   
        write-Host 'Getting DPS from Azure'
        if(-not([string]::IsNullOrEmpty($global:echoCommands)))
        {
            write-Host "Get DPS Command:"
            write-host "$global:DPSStrn =  az iot dps list --resource-group $GroupName  -o tsv | Out-String "
        }
        $global:DPSStrn =  az iot dps list --resource-group $GroupName   -o tsv | Out-String
    }
    If ([string]::IsNullOrEmpty($global:DPSStrn ))
    {
        $Prompt = 'No DPS found in Group "' + $GroupName + '".'
        write-Host $Prompt
        $Prompt ='Do you want to create a new DPS for the Group "'+ $GroupName +'"?'
        write-Host $prompt
        get-yesorno $true
	$answer =  $global:retVal
        if ($answer )
        {
            write-Host 'New DPS for the Group'
            $global:retVal = 'New'
        }
        else {
            write-Host 'Returning'
            $global:retVal = 'Back'
        }
        return
    }

    $options = 'N. New,D. Delete,B. Back' 

    If (-not [string]::IsNullOrEmpty($HubName ))
    {
        If (-not [string]::IsNullOrEmpty($env:IOTHUB_CONN_STRING_CSHARP ))
        {
            If (-not [string]::IsNullOrEmpty($global:HubsStrn ))
            {
                If (-not [string]::IsNullOrEmpty($Current ))
                {
                    $options = 'N. New,D. Delete,C. Connect Hub to DPS,I. dIsconnect Hub from DPS,B. Back' 
                }
            }
        }
    }
    parse-list $global:DPSStrn   '  D P S  '  $options $DPSStrnIndex $DPSStrnIndex 2  22 $Current
    $answer= $global:retVal

    If ([string]::IsNullOrEmpty($answer)) 
    {
        write-Host 'Back'
        $answer = 'Back'
    }
    elseif ($answer-eq 'Back')
    {
        write-Host 'Back'
    }
    elseif ($answer -eq 'New')
    {
        write-Host 'New'
    }
    elseif ($answer -eq 'Delete')
    {
        write-Host 'Delete'
    }
    elseif ($answer -eq 'CONNECT_IOT_HUB_TO_DPS')
    {
        $DPSName = $Current
        $global:DPSName = $Current 
        $global:retVal =  $Current
        write-host "About to run (Press [Enter] to continue):"
        read-host "az iot dps linked-hub create --dps-name $DPSName --resource-group $GroupName --connection-string $env:IOTHUB_CONN_STRING_CSHARP  --location $location -o table"
        az iot dps linked-hub create --dps-name $DPSName --resource-group $GroupName --connection-string $env:IOTHUB_CONN_STRING_CSHARP  --location $location  -o table
        write-Host ''
        write-Host "$DPSName :"
        az iot dps show --name $DPSName -o table
        get-anykey
    }
    elseif ($answer -eq 'DISCONNECT_IOT_HUB_FROM_DPS')
    {
        $DPSName = $Current
        $global:DPSName = $Current 
        $global:retVal =  $Current
        $ExtenedHubName = "$HubName.azure-devices.net"
        write-host "About to run (Press [Enter] to continue):"
        read-host "az iot dps linked-hub delete --dps-name $DPSName --resource-group $GroupName --linked-hub $ExtenedHubName -o table"
        $ExtenedHubName = "$HubName.azure-devices.net"
        az iot dps linked-hub delete --dps-name $DPSName --resource-group $GroupName --linked-hub $ExtenedHubName -o table
        write-Host ''
        write-Host "$DPSName :"
        az iot dps show --name $DPSName -o table
        get-anykey
    }
    elseif ($answer -ne $global:DPSName)
    {
        $global:DPSName = $answer 
        $global:retVal =  $answer
    }
    elseif ($answer -eq 'Error')
    {
        write-Host 'Error'

    }
    $global:retval = $answer 
}