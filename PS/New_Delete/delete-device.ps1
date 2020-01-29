function Delete-Device{
param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$DeviceName='',
    [boolean]$Refresh=$false
)

    $DeviceStrnIndex =5
    $DeviceStrnDataIndex =5 

    If ([string]::IsNullOrEmpty($Subscription ))
    {
        write-Host ''
        $prompt =  'Need to select a Subscription first.'
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
        $prompt =  'Need to select an IoT Hub first.'
       get-anykey $prompt
       $global:retVal = 'Back'
       return
    }

    $Refresh = $true
    if ($Refresh -eq $true)
    {
        $global:DevicesStrn  = $null
    }

    util\heading '  D E L E T E  D E V I C E  '   DarkRed  White

    # Need a Device name
    if ([string]::IsNullOrEmpty($DeviceName))
    {
    
        If ([string]::IsNullOrEmpty($global:DevicesStrn )) 
        {   
            write-Host 'Getting IoT Hub Devices from Azure'
            if(-not([string]::IsNullOrEmpty($global:echoCommands)))
            {
                write-Host "Get Devices Command:"
                write-host "$global:DevicesStrn =  az iot hub device-identity list  --hub-name $HubName --resource-group $GroupName -o tsv | Out-String "
            }
            $global:DevicesStrn =  az iot hub device-identity list  --hub-name $HubName --resource-group $GroupName -o tsv | Out-String 
        }
        If ([string]::IsNullOrEmpty($global:DevicesStrn ))
        {
            $Prompt = 'No Devices found in Hub'
           get-anykey $prompt
           $global:retVal = 'Back'
           return
        }
        parse-list $global:DevicesStrn  'Device' 'B. Back' $DeviceStrnIndex  $DeviceStrnIndex  1 22
        $answer = $global:retVal 
        If ([string]::IsNullOrEmpty($answer ))
        {
            $global:retVal = 'Back'
            return
        }

        elseif ($answer -eq 'Back')
        {
            $global:retVal = 'Back'
            return
        }
        elseif ($answer -eq 'Error')
        {
            $global:retVal = 'Error'
            return
        }
        $DeviceName = $answer
    }
    else {
        # Would've been selected from menu or just created so DevicesStrn should be current
    }


    $prompt =  'Do you want to delete the Device "' + $DeviceName +  '"'
    write-Host $prompt
   get-yesorno $false
   $answer = $global:retVal
    if (-not $answer)
    {
        $global:retVal = $false
        return
    }
    $global:DeviceName = $null
    $global:DevicesStrn = $null


    if ( util\check-device $Subscription $GroupName $HubName $DeviceName  )
    {
        $prompt = 'Deleting Azure IOT Hub Device "' + $DeviceName +'" in IoT Hub "' + $HubName + '" in Group "' + $GroupName +'"'
        write-Host $prompt
        if(-not([string]::IsNullOrEmpty($global:echoCommands)))
        {
            write-Host "Delete Device Command:"
            write-Host "az iot hub device-identity delete --device-id $DeviceName  --hub-name $HubName --resource-group $GroupName -o tsv | Out-String"
        }
        az iot hub device-identity delete --device-id $DeviceName  --hub-name $HubName --resource-group $GroupName -o tsv | Out-String


        $prompt =  'Checking whether Azure Resource "' + $DeviceName +'" in IoT Hub "' + $HubName + '" in Group "' + $GroupName +'" was deleted.'
        write-Host $prompt
        $global:DevicesStrn = $null
        if ( util\check-device $Subscription $GroupName $HubName $DeviceName  ) 
        {
            $prompt = 'It Failed.'
            get-anykey $prompt
            $global:retVal =  'Error'
        }
        else 
        {
            $prompt = 'It was deleted.'
            get-anykey $prompt
            $global:retVal = 'Back'
        }
    }
    else 
    {
        $prompt = 'Azure IOT Hub Device "' + $DeviceName +'" doesnt exist.'
        get-anykey $prompt
        $global:retVal = 'Back'
    }
}
