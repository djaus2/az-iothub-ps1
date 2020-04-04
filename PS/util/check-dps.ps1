function Check-DPS{
param (
    [Parameter(Mandatory)]
    [string]$Subscription,
    [Parameter(Mandatory)]
    [string]$GroupName,
    [Parameter(Mandatory)]
    [string]$DPSName,
    [boolean]$Refresh=$true
)
    # $DevicesStrnIndex =5

    $DPSStrnIndex =3
    $DPSStrnDataIndex =5

    if ($Refresh -eq $true)
    {
        $Refresh
        $global:DPSStrn  = $null
    }

    $prompt = 'Checking whether Azure IoT Hub DPS "' + $DPSName + '"  in Group "' + $GroupName + '" exists.'
    write-Host $prompt
    If ([string]::IsNullOrEmpty($global:DPSStrn ))
    {   
        write-Host 'Getting DPSs from Azure'
        $global:DPSStrn =  az iot dps list --subscription "$Subscription" --resource-group $GroupName -o tsv | Out-String
    }
    If ([string]::IsNullOrEmpty($global:DPSStrn  ))
    {
        $Prompt = 'No DPSs found in Group. Return'
        write-Host $Prompt
        $global:retVal = $false
        return $false
    }
    else
    {   
        $lines =$global:DPSStrn -split '\n'
        foreach ($line in $lines) 
        {
            if ([string]::IsNullOrEmpty($line))
            {   
                continue
            }
            $itemToList = ($line -split '\t')[$DPSStrnIndex]
            if ($itemToList -eq $DPSName)
            {
                $prompt = 'It exists'
                write-Host $prompt
                $global:retVal = $true
                return $true
            }
        }
        $prompt = 'DPS not found in Group.'
        write-Host $prompt
        $global:retVal = $false
        return $false
    }
   
}