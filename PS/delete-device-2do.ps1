param (
    [Parameter(Mandatory)]
    [string]$GroupName,
    [string]$HubName='',
    [boolean]$Refresh=$false
)

Clear-Host
write-Host ' AZURE IOT HUB SETUP: ' -NoNewline
write-Host '  D E L E T E  D E V I C E   '  -BackgroundColor Red -ForegroundColor White -NoNewline
write-Host ' using PowerShell'
write-Host ''
exit
# Need a Hub name
if ([string]::IsNullOrEmpty($HubName))
{
  
    If ( ([string]::IsNullOrEmpty($global:HubsStrn )) -or $Refresh)
    {   
        write-Host 'Getting Hubs from Azure'
        $global:HubsStrn =  az IoT Hub list --resource-group  $GroupName -o tsv | Out-String
    }
    If ([string]::IsNullOrEmpty($global:HubsStrn ))
    {
        $Prompt = 'No Hubs found in Subscription. Returning.'
        write-Host $Prompt
        return false
    }

    $HubName = show-menu $global:HubsStrn  'Hub'  3 3 1 22
    if ($HubName -eq 'Exit')
    {
        exit
    }
    elseif ($HubName -eq 'Back')
    {
       return $false
    }
    elseif ([string]::IsNullOrEmpty($HubName))
    {
        $prompt = 'Hub Name is blank or null. Returning'
        write-Host $prompt
        return $false
    }

}

$prompt =  'Do you want to delete the Hub "' + $HubName +  '" Y/N (Default N)'
$answer = read-Host $prompt
if  (($answer -eq 'N') -OR ($answer -eq 'n'))
{
    return $false
}


if (  ( check-hub $GroupName $HubName  $Refresh ) -eq $true)
{
    $prompt = 'Deleting Azure Resource Hub "' + $HubName + '" in Group "' + $GroupName +'"'
    write-Host $prompt
    az iot hub delete --name $HubName   --resource-group $GroupName
}
else 
{
    $prompt = 'Azure Resource Hub "' + $HubName +'" doesnt exist. Returning'
    write-Host $prompt
    return $false
}

$prompt = 'Checking whether Azure Hub "' + $HubName   +'" was deleted.'
write-Host $prompt
if (  ( check-hub $GroupName $HubName  $True   ) -eq $true)
{
    $prompt = 'It Failed'
    write-Host $prompt
    return  $false
}
else 
{
    $prompt = 'It was deleted.'
    write-Host $prompt
    return $true
}
