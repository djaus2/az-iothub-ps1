function New-Hub{
param (
    [Parameter(Mandatory)]
    [string]$Subscription = '' ,
    [Parameter(Mandatory)]
    [string]$GroupName='',
    [string]$HubName='',
    [string]$SKU =''
)
. ("$global:ScriptDirectory\Util\Check-Hub.ps1")

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
        $prompt= 'Need to select a Group first.'
        get-anykey $prompt
        $global:retVal = 'Back'
        return
    }

    # Force Refresh
    $Refresh = $false #$true
    if ($Refresh)
    {
        $global:HubsStrn=$null
    }

    show-heading '  N E W  I o T  H U B  '   3



    #Need a Hub name
    if ([string]::IsNullOrEmpty($HubName))
    {
        $answer = get-name 'IoT Hub'
        if ($answer-eq 'Back')
        {
            write-Host 'Returning'
            $global:retVal = 'Back'
            return
        }
        $HubName = $answer
    }

if($false) {
    #Need an SKU
    $skus = 'B1,B2,B3,F1,S1,S2,S3'
    if ([string]::IsNullOrEmpty($SKU))
    {

        $answer = choose-selection $skus 'SKU' 'S1'
        # $answer = $global:retVal

        if ([string]::IsNullOrEmpty($answer))
        {
            $global:retVal = 'Back'
            return
        }
        elseif  ($answer -eq 'Back')
        {
            $global:retVal = 'Back'
            return
        }

        $SKU = $answer

    }
}


    if([string]::IsNullOrEmpty($global:SKU))
    {
        $global:SKU = get-SKU
        $result = $global:retVal

        $prompt = 'SKU for Hub is "' + $result +'"'
        write-Host $prompt

        if ([string]::IsNullOrEmpty($result))
        {
            $global:retVal=  'Back'
            return 'Back'
        }
        elseif ($result -eq 'Back')
        {
            $global:retVal=  'Back'
            return 'Back'
        }
        elseif ($result -eq 'Error')
        {
            $global:retVal=  'Error'
            return 'Error'
        }
        elseif ($result -eq 'Exit')
        {
            $global:retVal=  'Exit'
            return 'Exit'
        }
        $global:SKU = $result
    }

    $SKU= $global:SKU


    # $prompt = 'Checking whether Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName  +'" exists.'
    # write-Host $prompt
    if (check-hub  $Subscription $HubName ) 
    {
        $prompt = 'Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" already exists.'
        get-anykey $prompt
        $global:retVal = 'Exists'
        Return
    }

    $global:HubName = $null
    $global:HubsStrn = $null
    $global:DevicesStrn=$null
    $global:DeviceName=$null


    $prompt = 'Creating new Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" using SKU "' +$SKU +'"'
    write-Host $prompt

    if(-not([string]::IsNullOrEmpty($global:echoCommands)))
    {
        write-Host "Create Hub Command:" -ForeGroundColor DarkGreen
        write-Host "az iot hub create --name $HubName   --resource-group $GroupName  --subscription "$Subscription" --sku $SKU --output Table" -ForeGroundColor DarkBlue
        get-anykey
    }
    if ($SKU -eq "F1")
    {
        # Musr be --partion-count2 for F1
        az iot hub create --name $HubName   --resource-group $GroupName  --subscription "$Subscription" --sku $SKU --partion-count 2 --output Table
    }
    else {
        # Default is 4
        az iot hub create --name $HubName   --resource-group $GroupName  --subscription "$Subscription" --sku $SKU --output Table
    }

    $prompt = 'Checking whether Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" was created.'
    write-Host $prompt
    # Need to refresh the list of hubs
    $global:HubsStrn = $null
    if (check-hub  $Subscription $HubName)
    {
        $prompt = 'Hub was created.'
        get-anykey $prompt
        $global:HubName = $HubName
        $global:retVal = 'Done'
    }
    else 
    {
        #If not found after trying to create it, must be inerror
        $prompt = 'Hub not created.'
        get-anykey $prompt 'Exit'
        $global:retVal = 'Error'
    }
}

