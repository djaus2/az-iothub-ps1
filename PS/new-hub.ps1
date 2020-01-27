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
    write-Host = 'Need to select a Subscription first.'
    $menu\any-key $prompt
    return ''
}
elseIf ([string]::IsNullOrEmpty($GroupName ))
{
    write-Host ''
    write-Host = 'Need to select a Group first.'
    menu\any-key $prompt
    return ''
}

if ($Refresh)
{
	$global:HubsStrn=null
}

util\heading '  N E W  I o T  H U B  '   DarkGreen  White 



#Need a Hub name
if ([string]::IsNullOrEmpty($HubName))
{
    $answer = util\get-name 'IoT Hub'
    if ($answer-eq 'Back')
    {
        write-Host 'Returning'
        return 'Back'
    }
    $HubName = $answer
}


#Need an SKU
$skus = 'B1,B2,B3,F1,S1,S2,S3'
if ([string]::IsNullOrEmpty($SKU))
{
    $answer = menu\choose-menu $skus 'SKU' 'F1'

    if ([string]::IsNullOrEmpty($answer))
    {
        return 'Back'
    }
    elseif  ($answer -eq 'Back')
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
        $prompt = 'Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" already exists.'
        menu\any-key $prompt
        return 'Exists'
    }

    $global:HubName = $null
    $global:HubsStrn = $null
    $global:DevicesStrn=$null
    $global:DeviceName=$null

    write-Host ''
    $prompt = 'Creating new Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" using SKU "' +$SKU +'"'
    write-Host $prompt
    $prompt = ''
    write-Host $prompt
    write-Host ''

    az iot hub create --name $HubName   --resource-group $GroupName --sku $SKU | Out-String

    $prompt = 'Checking whether Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" was created.'
    write-Host $prompt
    # Need to refresh the list of hubs
    if ((util\check-hub  $GroupName $HubName  $true) -eq $true)
    {
        $prompt = 'Hub was created.'
        menu\any-key $prompt
	$global:HubName = $HubName
        return $HubName
    }
    else 
    {
        #If not found after trying to create it, must be inerror
        $prompt = 'Hub not created.'
        menu\any-key $prompt 'Exit'
        return 'Error'
    }
}
else {
    
    $prompt = 'Checking whether Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName  +'" exists.'
    write-Host $prompt
    if ((util\check-hub  $GroupName $HubName  $Refresh) -eq $true)
    {
        $prompt = 'Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" already exists.'
        menu\any-key $prompt
        return 'Exists'
    }

    $global:HubName = $null
    $global:HubsStrn = $null
    $global:DevicesStrn=$null
    $global:DeviceName=$null


    $prompt = 'Creating new Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" using SKU "' +$SKU +'"'
    write-Host $prompt

    az iot hub create --name $HubName   --resource-group $GroupName  --subscription $Subscription --sku $SKU | Out-String

    $prompt = 'Checking whether Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" was created.'
    write-Host $prompt
    # Need to refresh the list of hubs
    if ((util\check-hub  $GroupName $HubName  $true) -eq $true)
    {
        $prompt = 'Hub was created.'
        menu\any-key $prompt
	$global:HubName = $HubName
        return $HubName
    }
    else 
    {
        #If not found after trying to create it, must be inerror
        $prompt = 'Hub not created.'
        menu\any-key $prompt 'Exit'
        return 'Error'
    }

}

