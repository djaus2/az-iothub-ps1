function Do-Device{
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
    prompt =  'Need to select a Hub first.'
    menu\any-key $prompt
    return 'Back'
}

$DeviceStrnIndex =5
$DeviceStrnDataIndex =5



util\heading '  D E V I C E   '  -BG DarkBlue   -FG White
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
    $answer = menu\yes-no $Prompt 'N'
    if ($answer)
    {
        write-Host 'New Device'
        return 'New'
    }
    else {
        write-Host 'Returning'
        return 'Back'
    }
}

$answer = menu\parse-list $global:DevicesStrn   '  D E V I C E  '  'N. New,D. Delete,B. Back'  $DeviceStrnIndex $DeviceStrnDataIndex 1  22 $Current
write-Host $answer

If ([string]::IsNullOrEmpty($answer)) 
{
	write-Host 'Back'
    return 'Back'
}
elseif ($answer -eq 'Back')
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
}