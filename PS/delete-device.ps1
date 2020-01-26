param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$DeviceName='',
    [boolean]$Refresh=$false
)


If ([string]::IsNullOrEmpty($Subscription ))
{
    write-Host ''
    write-Host 'Need to select a Subscription first. Press any key to return.'
    $KeyPress = [System.Console]::ReadKey($true)
    return 'Back'
}
elseIf ([string]::IsNullOrEmpty($GroupName ))
{
    write-Host ''
    write-Host 'Need to select a Group first. Press any key to return.'
    $KeyPress = [System.Console]::ReadKey($true)
    return 'Back'
}
elseIf ([string]::IsNullOrEmpty($HubName ))
{
    write-Host ''
    write-Host 'Need to select an IoT Hub first. Press any key to return.'
    $KeyPress = [System.Console]::ReadKey($true)
    return 'Back'
}

$HubStrnIndex =3
if ($Refresh -eq $true)
{
    $Refresh
    $global:DevicesStrn  = $null
}

util\heading '  D E L E T E  D E V I C E  '   DarkRed  White

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

    $DeviceName = menu\show-menu $global:DevicessStrn  'Device'  $DeviceStrnIndex  $DeviceStrnIndex  1 22
    if ($DeviceName -eq 'Exit')
    {
        return 'Exit'
    }
    elseif ($DeviceName -eq 'Back')
    {
       return 'Back'
    }
    elseif ($DeviceName -eq 'Error')
    {
       return 'Error'
    }
    elseif ([string]::IsNullOrEmpty($DeviceName))
    {
        # Shouldn't get to here.
        $prompt = 'Device Name is blank or null. Returning'
        write-Host $prompt
        return 'Back'
    }
}

$prompt =  'Do you want to delete the Device "' + $DeviceName +  '" Y/N (Default N)'
$answer = read-Host $prompt
$answer = $answer.Trim()
if ([string]::IsNullOrEmpty($DeviceName))
{
    retrun 'Back
}
elseif  (($answer -eq 'N') -OR ($answer -eq 'n'))
{
    return 'Back
}
$global:DeviceName = null


if (  ( util\check-device $GroupName $HubName $DeviceName  $Refresh ) -eq $true)
{
    $prompt = 'Deleting Azure IOT Hub Device "' + $DeviceName +'" in IoT Hub "' + $HubName + '" in Group "' + $GroupName +'"'
    write-Host $prompt
    az iot hub device-identity delete --device-id $DeviceName  --hub-name $HubName -resource-group $GroupName -o tsv | Out-String
}
else 
{
    $prompt = 'Azure IOT Hub Device "' + $DeviceName +'" doesnt exist. . Press [Enter] to return.'
    read-Host $prompt
    return 'Back'
}

$prompt =  'Checking whether Azure Resource "' + $DeviceName +'" in IoT Hub "' + $HubName + '" in Group "' + $GroupName +'" was deleted.'
write-Host $prompt

if (  ( util\utilities\check-device $GroupName $HubName $DeviceName  $true ) -eq $true)
{
    $prompt = 'It Failed.  Press [Enter] to return.'
    read-Host $prompt
    return  'Back'
}
else 
{
    $prompt = 'It was deleted.  Press [Enter] to return.'
    read-Host $prompt
    return 'Back'
}
