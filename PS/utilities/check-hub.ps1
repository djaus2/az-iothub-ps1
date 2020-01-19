param (
    [Parameter(Mandatory)]
    [string]$GroupName,
    [Parameter(Mandatory)]
    [string]$HubName,
    [boolean]$Refresh=$false
)
$prompt = 'Checking whether Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" exits.'
write-Host $prompt
If( ([string]::IsNullOrEmpty($global:HubsStrn )) -or $Refresh)
{ 
    write-Host 'Getting Hubs from Azure'
    $global:HubsStrn =  az iot hub list --resource-group  $GroupName  -o tsv | Out-String
}
If (-not([string]::IsNullOrEmpty($global:HubsStrn )))
{   
    $Index = 3
    $lines =$global:HubsStrn -split '\n'
    foreach ($line in $lines) 
    {
        if ([string]::IsNullOrEmpty($line))
        {   
            continue
        }
        $itemToList = ($line -split '\t')[$Index]
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