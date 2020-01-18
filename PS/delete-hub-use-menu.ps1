param (
    [Parameter(Mandatory)]
    [string]$GroupName,
    [string]$HubName=''
)
# Need a Hub name
if ([string]::IsNullOrEmpty($HubName))
{
    If ([string]::IsNullOrEmpty($global:HubsStrn ))
    {   
        write-Host 'Getting Hubs from Azure'
        $global:HubsStrn =  az IoT Hub list --resource-group  $GroupName -o tsv | Out-String
        # $global:HubsStrn =  az Hub list --subscription  $global:Subscription -o tsv | Out-String
    }
    If ([string]::IsNullOrEmpty($global:HubsStrn ))
    {
        # $Prompt = 'No Hubs found in Subscription ' + $global:Subscription + '. Exiting.'
        $Prompt = 'No Hubs found in Subscription. Exiting.'
        write-Host $Prompt
        Exit
    }
    $HubName = show-menu $global:HubsStrn  'Hub'  4 4 1 22
    if ($HubName -eq 'Exit')
    {
        exit
    }
    elseif ($HubName -eq 'Back')
    {
       return
    }

}
$prompt =  'Do you want to delete the Hub "' + $HubName +  '" Y/N (Default N)'
$answer = read-Host $prompt
if  (($answer -eq 'N') -OR ($answer -eq 'n'))
{
    return
}


$prompt = 'Checking whether Azure Hub "' + $HubName  + '" exists.'
write-Host $prompt
if (  ( check-hub --HubName $HubName --GroupName $GroupName   ) -eq $true)
{
    $prompt = 'Deleting Azure Resource Hub "' + $HubName + '" in Group "' + $GroupName +'"'
    write-Host $prompt
    az iot hub delete --name $HubName   --resource-group $GroupName
}
else 
{
    $prompt = 'Azure Resource Hub "' + $HubName +'" doesnt exist. Returning'
    write-Host $prompt
    return
}

$prompt = 'Checking whether Azure Hub "' + $HubName   +'" was deleted.'
write-Host $prompt
if (  ( az Hub exists --name $HubName   ) -eq $true)
{
    $prompt = 'It Failed'
    write-Host $prompt
    return 
}
else 
{
    $prompt = 'It was deleted.'
    write-Host $prompt
}
