param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$Current='',
    [boolean]$Refresh=$false
)

If ([string]::IsNullOrEmpty($Subscription ))
{
    write-Host ''
    write-Host 'Need to select a Subscription first. Press any key to return.'
    $KeyPress = [System.Console]::ReadKey($true)
    return ''
}
elseIf ([string]::IsNullOrEmpty($GroupName ))
{
    write-Host ''
    write-Host 'Need to select a Group first. Press any key to return.'
    $KeyPress = [System.Console]::ReadKey($true)
    return ''
}
elseIf ([string]::IsNullOrEmpty($HubName ))
{
    write-Host ''
    write-Host 'Need to select a Hub first. Press any key to return.'
    $KeyPress = [System.Console]::ReadKey($true)
    return ''
}

$DeviceStrnIndex =3
$DeviceStrnDataIndex =3

if ($Refresh -eq $true)
{
    $global:DeviceNamesStrn = null
}


util\heading '  D E V I C E   '  -BG DarkRed   -FG White
$Prompt =  'Subscription :"' + $Subscription +'"'
write-Host $Prompt
$Prompt = '          Group :"' + $GroupName +'"'
write-Host $Prompt
$Prompt = '            Hub :"' + $HubName +'"'
write-Host $Prompt
$Prompt = ' Current Device :"' + $Current +'"'
write-Host $Prompt

[boolean]$skip = $false
if (-not ($global:GotDevicesStrn -eq $null))
{
    $skip = $global:GotDevicesStrn
}
If  (([string]::IsNullOrEmpty($global:DevicessStrn ))  -and (-not $skip))
{   
    write-Host 'Getting Devices from Azure'
    $global:DevicesStrn =  az iot hub device-identity list  --hub-name $HubName -o tsv | Out-String
    $global:GotDevicesStrn = $true
}
If ([string]::IsNullOrEmpty($global:DevicessStrn ))
{
    $Prompt = 'No Devices found in Hub "' + $HubName + '".'
    write-Host $Prompt
    $Prompt ='Do you want to create a new Device for the Hub "'+ $Hub +'"?'
    $answer = util\yes-no-menu $Prompt 'N'
    if (($answer -eq 'Y') -OR ($answer -eq 'y'))
    {
        write-Host 'New Device'
        return 'New'
    }
    else {
        write-Host 'Returning'
        return 'Back'
    }
}


# $GroupName = util\Show-Menu $global:GroupsStrn  '  G R O U P  ' 'N. New,D. Delete,B. Back'   $GroupStrnIndex  $GroupStrnIndex  3 40  $Current

$DeviceName = util\Show-Menu $global:DevicessStrn   '  H U B  '  'N. New,D. Delete,B. Back'  $DeviceStrnIndex $DeviceStrnDataIndex 2  22 $Current
write-Host $DeviceName

if ($DeviceName-eq 'Back')
{
    write-Host 'Back. Exit for now.'
    retrun 'Back'
}
elseif ($DeviceName -eq 'New')
{
    write-Host 'New'
    return 'New'
}
elseif ($DeviceName -eq 'Delete')
{
    write-Host 'Delete'
    return 'Delete'
}
elseif ($DeviceName -ne $global:HubName)
{
    $global:DeviceName = $DeviceName 
}
return $DeviceName 