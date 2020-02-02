function Check-Device{
param (
    [Parameter(Mandatory)]
    [string]$Subscription,
    [Parameter(Mandatory)]
    [string]$GroupName,
    [Parameter(Mandatory)]
    [string]$HubName,
    [Parameter(Mandatory)]
    [string]$DeviceName,
    [boolean]$Refresh=$false
)
    # $DevicesStrnIndex =5
    if ($Refresh -eq $true)
    {
        $Refresh
        $global:DevicesStrn  = $null
    }

    $prompt = 'Checking whether Azure IoT Hub Device "' + $DeviceName +'" in IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" exists.'
    write-Host $prompt
    If ([string]::IsNullOrEmpty($global:DevicesStrn ))
    {   
        write-Host 'Getting Devices from Azure'
        $global:DevicesStrn =  az iot hub device-identity list  --hub-name $HubName --resource-group $GroupName -o tsv | Out-String
    }
    If ([string]::IsNullOrEmpty($global:DevicesStrn  ))
    {
        $Prompt = 'No Devices found in Hub. Return'
        write-Host $Prompt
        return $false
    }
    else
    {   
        $lines =$global:DevicesStrn -split '\n'
        foreach ($line in $lines) 
        {
            if ([string]::IsNullOrEmpty($line))
            {   
                continue
            }
            $itemToList = ($line -split '\t')[$DevicesStrnIndex]
            if ($itemToList -eq $DeviceName)
            {
                $prompt = 'It exists'
                write-Host $prompt
                return $true
            }
        }
        $prompt = 'Device not found in Hub.'
        write-Host $prompt
        return $false
    }
    else 
    {
        $prompt = 'No Devices found for Hub.'
        write-Host $prompt
        return false
    }
}