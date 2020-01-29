function New-Device{
param (
    [string]$Subscription = '' ,
    [string]$GroupName='',
    [string]$HubName='',
    [string]$DeviceName ='',
    [Nullable[boolean]]$EdgeEnabled=$false,
    [boolean]$Refresh=$false
)

    $DeviceName=$null

    If ([string]::IsNullOrEmpty($Subscription ))
    {
        write-Host ''
        $prompt = 'Need to select a Subscription first.'
        get-anykey $prompt
        $global:retVal = 'Back'
        return 
    }
    elseIf ([string]::IsNullOrEmpty($GroupName ))
    {
        write-Host ''
        $prompt = 'Need to select a Group first.'
        get-anykey $prompt
        $global:retVal = 'Back'
        return 
    }
    elseIf ([string]::IsNullOrEmpty($HubName ))
    {
        write-Host ''
        $prompt = 'Need to select an IoT Hub first.'
        get-anykey $prompt
        $global:retVal = 'Back'
        return 
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
            $global:retVal = 'Back'
            return
        }
        $DeviceName = $answer
    }







    # Is it edge enabled. Not required for SDK Quickstarts
    if ([string]::IsNullOrEmpty($EdgeEnabled))
    {
        $EdgeEnabled = $false

        $prompt = 'Do you want it to be Edge Enabled? Not required for IoT Hub SDK Quickstarts.'
        $answer= menu\yes-no $prompt 'N'
        If ($answer)
        {
            $EdgeEnabled = true
        }     
    }

    if ((util\check-device $Subscription $GroupName $HubName $DeviceName $Refresh) -eq $true)
    {
        $prompt = 'Azure IoT Hub Device "' + $DeviceName + '" in IoT Hub "'+ $HubName +'" in Group "' + $GroupName + '" already exists.'
        get-anykey $prompt
        $global:retVal =  'Exists'
        return
    }

    $global:DevicesStrn = $null
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
        get-anykey $prompt
        $global:DeviceName=$DeviceName
        $global:retVal = $DeviceNamee
    }
    else 
    {
        #If not found after trying to create it, must be inerror
        $prompt = 'Device not created.'
        get-anykey $prompt 'Exit'
        $global:retVal =  'Error'
    }
}


