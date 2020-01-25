param (
    [string]$GroupName='',
    [string]$HubName='',
    [string]$DeviceName ='',
    [boolean]$EdgeEnabled=$false,
    [boolean]$Refresh=$false
)

Clear-Host
write-Host ' AZURE IOT HUB SETUP: ' -NoNewline
write-Host '  N E W  D E V I C E  '  -BackgroundColor DarkBlue  -ForegroundColor White -NoNewline
write-Host ' using PowerShell'
write-Host ''

$global:DeviceName  = $null


# Need a group name
if ([string]::IsNullOrEmpty($GroupName))
{
    do
    {
        $prompt = 'Enter Resource Group Name, X to exit/return'
        if (-not ([string]::IsNullOrEmpty($answer)))
        {
            $answer= read-Host $prompt
            $answer = $answer.Trim()
            write-Host $answer
        }      
    } until (-not ([string]::IsNullOrEmpty($answer)))
    if ($answer.ToUpper() -eq 'X')
    {
        write-Host 'Returning'
        return 'Back'
    }
    $GroupName = $answer
}

#Need a Hub name
if ([string]::IsNullOrEmpty($HubName))
{
    do
    {
        $prompt = 'Enter IoT Hub Name, X to exit/return'
        $answer= read-Host $prompt
        $answer = $answer.Trim()
        write-Host $answer
        
    } until (-not ([string]::IsNullOrEmpty($answer)))
    if ($answer.ToUpper() -eq 'X')
    {
        write-Host 'Returning'
        return 'Return'
    }
    $HubName = $answer
}

#Need a Device name
if ([string]::IsNullOrEmpty($DeviceName))
{
    do
    {
        $prompt = 'Enter Device Name, X to exit/return'
        $answer= read-Host $prompt   
        $answer = $answer.Trim()
        write-Host $answer       
    } until (-not ([string]::IsNullOrEmpty($answer)))
    if ($answer.ToUpper() -eq 'X')
    {
        write-Host 'Returning'
        return 'Return'
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



if ((utilities\check-device  $GroupName $HubName $DeviceName $Refresh) -eq $true)
{
    $prompt = 'Azure IoT Hub Device "' + $DeviceName + '" in IoT Hub "'+ $HubName +'" in Group "' + $GroupName + '" already exists. Returning'
    write-Host $prompt
    return 'Exists'
}

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

$prompt = 'Checking whether Azure IoT Hub Device "' + $DeviceName + '" in IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" was created.'
write-Host $prompt
# Need to refresh the list of devices
if ((utilities\check-device  $GroupName $HubName $DeviceName $true ) -eq $true)
{
    $prompt = 'Device was created. Press [Enter] to return.'
    read-Host $prompt
    $global:DeviceName = $DeviceName
    return $DeviceName
}
else 
{
    #If not found after trying to create it, must be inerror
    $prompt = 'Device not created. Press [Return] to exit.'
    read-Host $prompt
    $global:DeviceName = $null
    $global:DevicesStrn = $null
    return 'Error'
}

