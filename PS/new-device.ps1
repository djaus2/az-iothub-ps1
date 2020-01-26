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
    write-Host 'Need to select an IoT Hub first. Press any key to return.'
    $KeyPress = [System.Console]::ReadKey($true)
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
    if ($answer.ToUpper() -eq 'B')
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
    # do
    #{
        $prompt = 'Do you want it to be Edge Enabled? Not required for IoT Hub SDK Quickstarts.'
        write-Host $prompt
        $prompt = 'Y/N (Default N). X to exit/return'
        $answer= read-Host $prompt
        if ([string]::IsNullOrEmpty($answer))
        {
            $answer ='Y'
        }
        $answer = $answer.ToUpper()
        $answer = $answer.Trim()
        write-Host $answer
        If ($answer = 'Y')
        {
            $EdgeEnabled = true
        }
        
    # } until (-not ([string]::IsNullOrEmpty($answer)))
}

$prompt = 'Checking whether Azure IoT Hub Device "' + $DeviceName +'" in Hub "' + $HubName + '"  in Group "' + $GroupName + '" exists.'
write-Host $prompt

if ((util\check-device $Subscription $GroupName $HubName $DeviceName $Refresh) -eq $true)
{
    $prompt = 'Azure IoT Hub Device "' + $DeviceName + '" in IoT Hub "'+ $HubName +'" in Group "' + $GroupName + '" already exists. Returning'
    write-Host $prompt
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
    $prompt = 'Device was created. Press [Enter] to return.'
    read-Host $prompt
    $global:DeviceName=$DeviceName
    return $DeviceName
}
else 
{
    #If not found after trying to create it, must be inerror
    $prompt = 'Device not created. Press [Return] to exit.'
    read-Host $prompt
    $global:DevicesStrn=$null
    $global:DeviceName=$null
    return 'Error'
}


