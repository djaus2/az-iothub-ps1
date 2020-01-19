param (
    [Parameter(Mandatory)]
    [string]$GroupName,
    [Parameter(Mandatory)]
    [string]$HubName,
    [Parameter(Mandatory)]
    [string]$DeviceName,
    [boolean]$Refresh=$false
)
$prompt = 'Checking whether Azure IoT Hub Device "' + $DeviceName +'" in IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" exits.'
write-Host $prompt
If (([string]::IsNullOrEmpty($global:DevicesStrn )) -or $Refesh)
{   
    write-Host 'Getting Devices from Azure'
    $global:DevicesStrn =  az iot hub device-identity list  --hub-name $HubName -o tsv | Out-String
}
If ([string]::IsNullOrEmpty($global:DevicesStrn  ))
{
    $Prompt = 'No Devices found in Hub. Exiting.'
    exit
}
If (-not([string]::IsNullOrEmpty($global:DevicesStrn )))
{   
    $Index = 3
    $lines =$global:HubsStrn -split '\n'
    foreach ($line in $lines) 
    {
        $line
        if ([string]::IsNullOrEmpty($line))
        {   
            continue
        }
        $itemToList = ($line -split '\t')[$Index]
        $itemToList
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