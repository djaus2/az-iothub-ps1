param (
    [Parameter(Mandatory)]
    [string]$GroupName,
    [string]$HubName='',
    [boolean]$Refresh=$false
)

$DevicesStrnIndex =5
if ($Refresh -eq $true)
{
    $Refresh
    $global:DevicesStrn  = $null
}

Clear-Host
write-Host ' AZURE IOT HUB SETUP: ' -NoNewline
write-Host '  D E L E T E  D E V I C E   '  -BackgroundColor Red -ForegroundColor White -NoNewline
write-Host ' using PowerShell'
write-Host ''
exit

$global:DeviceName = null
# Need a Hub name
if ([string]::IsNullOrEmpty($DeviceName))
{
  
    If ([string]::IsNullOrEmpty($global:DevicesStrn )) 
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

    $DeviceName = utilities\show-menu $global:DeicessStrn  'Device'  $DevicesStrnIndex  $DevicesStrnIndex  1 22
    if ($DeviceName -eq 'Exit')
    {
        exit
    }
    elseif ($DeviceName -eq 'Back')
    {
       return $false
    }
    elseif ([string]::IsNullOrEmpty($DeviceName))
    {
        # Shouldn't get to here.
        $prompt = 'Device Name is blank or null. Returning'
        write-Host $prompt
        return $false
    }
}

$prompt =  'Do you want to delete the Device "' + $DeviceName +  '" Y/N (Default N)'
$answer = read-Host $prompt
$answer = $answer.Trim()
if ([string]::IsNullOrEmpty($DeviceName))
{
    retrun $false
}
elseif  (($answer -eq 'N') -OR ($answer -eq 'n'))
{
    return $false
}


if (  ( utilities\check-device $GroupName $HubName $DeviceName  $Refresh ) -eq $true)
{
    $prompt = 'Deleting Azure IOT Hub Device "' + $DeviceName +'" in IoT Hub "' + $HubName + '" in Group "' + $GroupName +'"'
    write-Host $prompt
    az iot hub device-identity delete --device-id $DeviceName  --hub-name $HubName -resource-group $GroupName -o tsv | Out-String
}
else 
{
    $prompt = 'Azure IOT Hub Device "' + $DeviceName +'" doesnt exist. Returning'
    write-Host $prompt
    return $false
}

$prompt =  $DeviceName +'" in IoT Hub "' + $HubName + '" in Group "' + $GroupName +'" was deleted.'
write-Host $prompt

if (  ( utilities\check-device $GroupName $HubName $DeviceName  $true ) -eq $true)
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
