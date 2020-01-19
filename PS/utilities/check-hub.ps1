param (
    [Parameter(Mandatory)]
    [string]$GroupName,
    [Parameter(Mandatory)]
    [string]$HubName,
    [boolean]$Refresh=$false
)

$HubsStrnIndex =5
if ($Refresh -eq $true)
{
    $Refresh
    $global:HubsStrn  = $null
}

$prompt = 'Checking whether Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" exits.'
write-Host $prompt
If([string]::IsNullOrEmpty($global:HubsStrn )) 
{ 
    write-Host 'Getting Hubs from Azure'
    $global:HubsStrn =  az iot hub list --resource-group  $GroupName  -o tsv | Out-String
}
If (-not([string]::IsNullOrEmpty($global:HubsStrn )))
{   
    $lines =$global:HubsStrn -split '\n'
    foreach ($line in $lines) 
    {
        if ([string]::IsNullOrEmpty($line))
        {   
            continue
        }
        $itemToList = ($line -split '\t')[$HubsStrnIndex ]
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
    $prompt = 'No Hubs not found.'
    write-Host $prompt
    return false
}