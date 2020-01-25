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

$DeviceStrnIndex =5
$DeviceStrnDataIndex =5



util\heading '  D E V I C E   '  -BG DarkRed   -FG White
$Prompt = '   Subscription :"' + $Subscription +'"'
write-Host $Prompt
$Prompt = '          Group :"' + $GroupName +'"'
write-Host $Prompt
$Prompt = '            Hub :"' + $HubName +'"'
write-Host $Prompt
$Prompt = ' Current Device :"' + $Current +'"'
write-Host $Prompt

if ($Refresh -eq $true)
{
    $global:DeviceNamesStrn = null
}
[boolean]$skip = $false
if  ($global:DevicesStrn -eq '')
{
    # This allows for previously returned empty string
    $skip = $true
}
If  (([string]::IsNullOrEmpty($global:DevicesStrn  ))  -and (-not $skip))
{   
    write-Host 'Getting Devices from Azure'
    $global:DevicesStrn =  az iot hub device-identity list  --hub-name $HubName -o tsv | Out-String
}
If ([string]::IsNullOrEmpty($global:DevicesStrn ))
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
    return 'Back'
}

$answer = util\Show-Menu $global:DevicesStrn   '  D E V I C E  '  'N. New,D. Delete,B. Back'  $DeviceStrnIndex $DeviceStrnDataIndex 1  22 $Current
write-Host $answer

If ([string]::IsNullOrEmpty($answer)) 
{
	write-Host 'Back'
    return 'Back'
}
elseif ($answer -eq 'Return')
{
	write-Host 'Back'
    return 'Back'
}
elseif ($answer -eq 'New')
{
    write-Host 'New'
    return 'New'
}
elseif ($answer -eq 'Delete')
{
    write-Host 'Delete'
    return 'Delete'
}
elseif ($answer -ne $global:DeviceName)
{
    $global:DeviceName = $answer 
}
elseif ($answer -eq 'Error')
{
	write-Host 'Error'
    return 'Error'
}
return $answer 