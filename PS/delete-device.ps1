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
    $prompt =  'Need to select a Subscription first.'
    menu\any-key $prompt
    return 'Back'
}
elseIf ([string]::IsNullOrEmpty($GroupName ))
{
    write-Host ''
    $prompt = 'Need to select a Group first.'
    menu\any-key $prompt
    return 'Back'
}
elseIf ([string]::IsNullOrEmpty($HubName ))
{
    write-Host ''
    $prompt =  'Need to select an IoT Hub first.'
    menu\any-key $prompt
    return 'Back'
}

$HubStrnIndex =3
if ($Refresh -eq $true)
{
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
        $Prompt = 'No Devices found in Hub'
	    menu\any-key $prompt
        return 'Back'
    }

    $DeviceName = menu\show-menu $global:DevicessStrn  'Device'  $DeviceStrnIndex  $DeviceStrnIndex  1 22

    If ([string]::IsNullOrEmpty($HubName ))
    {
        return 'Back'
    }

    elseif ($DeviceName -eq 'Back')
    {
       return 'Back'
    }
    elseif ($DeviceName -eq 'Error')
    {
       return 'Error'
    }
}

$prompt =  'Do you want to delete the Device "' + $DeviceName +  '"'
$answer = menu\yes-no $prompt 'N'
if ([string]::IsNullOrEmpty($DeviceName))
{
    return 'Back'
}
elseif  (($answer -eq 'N') -OR ($answer -eq 'n'))
{
    return 'Back'
}
$global:DeviceName = null
$global:DevicesStrn=$null


if (  ( util\check-device $GroupName $HubName $DeviceName  $Refresh ) -eq $true)
{
    $prompt = 'Deleting Azure IOT Hub Device "' + $DeviceName +'" in IoT Hub "' + $HubName + '" in Group "' + $GroupName +'"'
    write-Host $prompt
    az iot hub device-identity delete --device-id $DeviceName  --hub-name $HubName -resource-group $GroupName -o tsv | Out-String
}
else 
{
    $prompt = 'Azure IOT Hub Device "' + $DeviceName +'" doesnt exist.'
    menu\any-key $prompt
    return 'Back'
}

$prompt =  'Checking whether Azure Resource "' + $DeviceName +'" in IoT Hub "' + $HubName + '" in Group "' + $GroupName +'" was deleted.'
write-Host $prompt

if (  ( util\utilities\check-device $GroupName $HubName $DeviceName  $true ) -eq $true)
{
    $prompt = 'It Failed.'
    menu\any-key $prompt
    return  'Error'
}
else 
{
    $prompt = 'It was deleted.'
    menu\any-key $prompt
    return 'Back'
}
