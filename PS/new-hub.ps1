param (
    [string]$Subscription = '' ,
    [string]$GroupName='',
    [string]$HubName='',
    [string]$SKU ='',
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

if ($Refresh)
{
	$global:HubsStrn=null
}

util\heading '  N E W  I o T  H U B  '   DarkBlue  White 

$global:HubName = $null
$global:DevicesStrn=$null
$global:DeviceName=$null

#Need a Hub name
# Need a group name
if ([string]::IsNullOrEmpty($HubName))
{
    $answer = util\get-name 'IoT Hub'
    if ($answer.ToUpper() -eq 'B')
    {
        write-Host 'Returning'
        return 'Back'
    }
    $HubName = $answer
}


#We need an SKU
$skus = 'B1, B2, B3, F1, S1, S2, S3'
if ([string]::IsNullOrEmpty($SKU))
{
    $answer = util\choose-menu $skus.Replace(' ' , '') 'SKU' 'F1'
  if ([string]::IsNullOrEmpty($SKU))
    {
        return 'Back'
    }
    elseif  ($SKU -eq 'Back')
    {
        return 'Back'
    }

    $SKU= $answer
}

# Subscription is  optional
if ([string]::IsNullOrEmpty($Subscription)) 
{

    $prompt = 'Checking whether Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName  +'" exists.'
    write-Host $prompt
    if ((util\check-hub  $GroupName $HubName  $Refresh) -eq $true)
    {
        $prompt = 'Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" already exists. Returning'
        read-Host $prompt
        return 'Exists'
    }


    $prompt = 'Creating new Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" using SKU "' +$SKU +'"'
    write-Host $prompt

    az iot hub create --name $HubName   --resource-group $GroupName --sku $SKU

    $prompt = 'Checking whether Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" was created.'
    write-Host $prompt
    # Need to refresh the list of hubs
    if ((utilities\check-hub  $GroupName $HubName  $true) -eq $true)
    {
        $prompt = 'Hub was created. Press [Enter] to return.'
        read-Host $prompt
        $global:HubName = $HubName
        $global:DevicesStrn=$null
        $global:DeviceName=$null
        return $HubName
    }
    else 
    {
        #If not found after trying to create it, must be inerror
        $prompt = 'Hub not created. Press [Return] to exit.'
        read-Host $prompt
        $global:HubName = $null
        $global:HubsStrn = $null
        $global:DevicesStrn=$null
        $global:DeviceName=$null
        return 'Error'
    }
}
else {
    {
        $prompt = 'Checking whether Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName  +'" exists.'
        write-Host $prompt
        if ((util\check-hub  $GroupName $HubName  $Refresh) -eq $true)
        {
            $prompt = 'Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" already exists. Returning'
            read-Host $prompt
            return 'Exists'
        }
    
    
        $prompt = 'Creating new Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" using SKU "' +$SKU +'"'
        write-Host $prompt
    
        az iot hub create --name $HubName   --resource-group $GroupName  --subscription $Subscription --sku $SKU
    
        $prompt = 'Checking whether Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" was created.'
        write-Host $prompt
        # Need to refresh the list of hubs
        if ((utilities\check-hub  $GroupName $HubName  $true) -eq $true)
        {
            $prompt = 'Hub was created. Press [Enter] to return.'
            read-Host $prompt
            $global:HubName = $HubName
            $global:DevicesStrn=$null
            $global:DeviceName=$null
            return $HubName
        }
        else 
        {
            #If not found after trying to create it, must be inerror
            $prompt = 'Hub not created. Press [Return] to exit.'
            read-Host $prompt
            $global:HubName = $null
            $global:HubsStrn = $null
            $global:DevicesStrn=$null
            $global:DeviceName=$null
            return 'Error'
        }
    }
}

