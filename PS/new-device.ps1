param (
    [string]$Subscription = '' ,
    [string]$GroupName='',
    [string]$HubName='',
    [string]$DeviceName ='',
    [boolean]$EdgeEnabled=$false,
    [boolean]$Refresh=$false
)

If ([string]::IsNullOrEmpty($Subscription ))
{
    write-Host ''
    $prompt = 'Need to select a Subscription first.'
    menu\any-key $prompt
    return ''
}
elseIf ([string]::IsNullOrEmpty($GroupName ))
{
    write-Host ''
    $prompt = 'Need to select a Group first.'
    menu\any-key $prompt
    return ''
}
elseIf ([string]::IsNullOrEmpty($HubName ))
{
    write-Host ''
    $prompt = 'Need to select an IoT Hub first.'
    menu\any-key $prompt
    return ''
}

if ($Refresh)
{
	$global:DevicesStrn=null
}

util\heading '  N E W  D E V I C E   '   DarkGreen  White 



# Need a Device name
if ([string]::IsNullOrEmpty($DeviceName))
{
    $answer = util\get-name 'Device'
    if ($answer.ToUpper() -eq 'Back')
    {
        write-Host 'Returning'
        return 'Back'
    }
    $DeviceName = $answer
}







# Is it edge enabled. Not required for SDK Quickstarts
if ([string]::IsNullOrEmpty($EdgeEnabled))
{
    $EdgeEnabled = $false

    $prompt = 'Do you want it to be Edge Enabled? Not required for IoT Hub SDK Quickstarts.'
    $answer= menu\yes-no $prompt 'N'
    if ([string]::IsNullOrEmpty($answer))
    {
        $answer ='N'
    }
    write-Host $answer
    If ($answer = 'Y')
    {
        $EdgeEnabled = true
    }     
}

$prompt = 'Checking whether Azure IoT Hub Device "' + $DeviceName +'" in Hub "' + $HubName + '"  in Group "' + $GroupName + '" exists.'
write-Host $prompt

if ((util\check-device $Subscription $GroupName $HubName $DeviceName $Refresh) -eq $true)
{
    $prompt = 'Azure IoT Hub Device "' + $DeviceName + '" in IoT Hub "'+ $HubName +'" in Group "' + $GroupName + '" already exists.'
    menu\any-key $prompt
    return 'Exists'
}

$global:DeviceName  = $null

write-Host ''
$prompt = 'Creating new Azure IoT Hub Device "' + $DeviceName + '" in IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" with default authorization (shared private key).'
write-Host $prompt
$prompt = 'See https://docs.microsoft.com/en-us/cli/azure/ext/azure-cli-iot-ext/iot/hub/device-identity?view=azure-cli-latest#code-try-4 for further device options'
write-Host $prompt
write-Host ''

if ($EdgeEnabled)
{
    az iot hub device-identity create -n $HubName -d  $DeviceName  --resource-group $GroupName --ee-o tsv | Out-String
}
else
{
    az iot hub device-identity create -n $HubName -d  $DeviceName  --resource-group $GroupName   -o tsv | Out-String
}

$prompt = 'Checking whether Azure IoT Hub Device "' + $DeviceName +'" in Hub "' + $HubName + '"  in Group "' + $GroupName + '" was created.'
write-Host $prompt
# Need to refresh the list of hubs
if ((util\check-device $Subscription  $GroupName $HubName  $DeviceName $true) -eq $true)
{
    $prompt = 'Device was created.'
    menu\any-key $prompt
    $global:DeviceName=$DeviceName
    return $DeviceName
}
else 
{
    #If not found after trying to create it, must be inerror
    $prompt = 'Device not created.'
    menu\any-key $prompt
    $global:DevicesStrn=$null
    $global:DeviceName=$null
    return 'Error'
}


