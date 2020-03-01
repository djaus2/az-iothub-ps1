function Check-Hub{
param (
    [Parameter(Mandatory)]
    [string]$Subscription,
    [Parameter(Mandatory)]
    [string]$GroupName,
    [Parameter(Mandatory)]
    [string]$HubName,
    [boolean]$Refresh=$false
)

    # $HubStrnIndex =3
    # $HubStrnDataIndex =3
    if ($Refresh -eq $true)
    {
        $Refresh
        $global:HubsStrn  = $null
    }

    $prompt = 'Checking whether Azure IoT Hub "' + $HubName +'" in Subscription "' + $Subscripton + '" exists.'
    write-Host $prompt
    If([string]::IsNullOrEmpty($global:HubsStrn )) 
    { 
        write-Host 'Getting Hubs from Azure'
        $global:HubsStrn =  az iot hub list --subscription $Subscription  -o tsv | Out-String
    }
    If (-not([string]::IsNullOrEmpty($global:HubsStrn )))
    {   
        $lines =$global:HubsStrn -split '\n'
        foreach ($linex in $lines) 
        {
            $line = $linex.Trim()
            if ([string]::IsNullOrEmpty($line))
            {   
                continue
            }
            $itemToList = ($line -split '\t')[$HubStrnDataIndex ]
            if ($itemToList -eq $HubName)
            {
                $prompt = 'It exists'
                write-Host $prompt
                return $true
            }
        }
        $prompt = 'Hub not found.'
        write-Host $prompt
        return $false
    }
    else 
    {
        $prompt = 'No Hubs found.'
        write-Host $prompt
        return $false
    }
}