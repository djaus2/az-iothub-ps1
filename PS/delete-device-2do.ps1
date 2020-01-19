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

$global:DeviceName = null
# Need a Hub name
if ([string]::IsNullOrEmpty($HubName))
{
  
    If ( ([string]::IsNullOrEmpty($global:DevicesStrn )) -or $Refresh)
    {   
        write-Host 'Getting IoT Hub Devices from Azure'
        $global:DevicesStrn =  az iot hub device-identity list  --hub-name $HubName -o tsv | Out-String 
    }
    If ([string]::IsNullOrEmpty($global:DevicesStrn ))
    {
        $Prompt = 'No Devices found in Hub. Returning.'
        write-Host $Prompt
        return false
    }

    $HubName = show-menu $global:DeicessStrn  'Hub'  3 3 1 22
    if ($DeviceName -eq 'Exit')
    {
        exit
    }
    elseif ($DeviceName -eq 'Back')
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
    az iot hub device-identity delete --device-id $DeviceName  --hub-name $HubName -resource-group $GroupName -o tsv | Out-String
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
