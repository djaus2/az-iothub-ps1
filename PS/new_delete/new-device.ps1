function New-Device{
param (
    [Parameter(Mandatory)]
    [string]$Subscription = '' ,
    [Parameter(Mandatory)]
    [string]$GroupName='',
    [Parameter(Mandatory)]
    [string]$HubName='',
    [string]$DeviceName ='',
    [Nullable[boolean]]$EdgeEnabled=$false,
    [boolean]$Refresh=$false
)

. ("$global:ScriptDirectory\Util\Check-Device.ps1")


show-heading '  N E W  D E V I C E   '   3

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
    elseIf (-not ([string]::IsNullOrEmpty($DeviceName )))
    {
        write-Host ''
        $prompt = "Do you want to use $DeviceName for the name of the new Device?"
        get-yesorno $false $prompt
        if (-not $global:retVal)
        {
            write-host "del"
            $DeviceName =''
        }
    }

    if ($Refresh)
    {
        $global:DevicesStrn=null
    }



    # Need a Device name
    if ([string]::IsNullOrEmpty($DeviceName))
    {
        $answer = get-name 'Device'
        if ($answer.ToUpper() -eq 'Back')
        {
            write-Host 'Returning'
            get-anykey
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

    if (check-device $Subscription $GroupName $HubName $DeviceName )
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
        if(-not([string]::IsNullOrEmpty($global:echoCommands)))
        {
            write-Host "Create Device Command:"
            write-Host "az iot hub device-identity create -n $HubName -d  $DeviceName  --resource-group $GroupName --ee-o Table"
        }
        az iot hub device-identity create -n $HubName -d  $DeviceName  --resource-group $GroupName --ee-o Table
    }
    else
    {
        if(-not([string]::IsNullOrEmpty($global:echoCommands)))
        {
            write-Host "Create Device Command:"
            write-Host "az iot hub device-identity create -n $HubName -d  $DeviceName  --resource-group $GroupName   -o Table"
        }
        az iot hub device-identity create -n $HubName -d  $DeviceName  --resource-group $GroupName  -o Table
    }


    $prompt = 'Checking whether Azure IoT Hub Device "' + $DeviceName +'" in Hub "' + $HubName + '"  in Group "' + $GroupName + '" was created.'
    write-Host $prompt
    
    # Need to refresh the list of devices
    $global:DevicesStrn = $null
    if (check-device $Subscription  $GroupName $HubName  $DeviceName )
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


