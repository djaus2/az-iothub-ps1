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


util\heading '  N E W  I o T  H U B  '   DarkBlue  White 

$global:HubName = $null

#Need a Hub name
if ([string]::IsNullOrEmpty($HubName))
{
    do
    {
        $prompt = 'Enter IoT Hub Name, X to return'
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


#We need an SKU
$skus = 'B1, B2, B3, F1, S1, S2, S3'
$skusList = $skus.Replace(' ', '')
if ([string]::IsNullOrEmpty($SKU))
{
    # do
    #{
        $prompt = 'Enter SKU. Choose from ' + $skus + '. X to exit/return'
        $answer= read-Host $prompt
        if ([string]::IsNullOrEmpty($answer))
        {
            $answer ='F1'
        }
        $answer = $answer.ToUpper()
        $answer = $answer.Trim()
        write-Host $answer
        
    # } until (-not ([string]::IsNullOrEmpty($answer)))

    if ($answer -eq 'X')
    {
        write-Host 'Returning'
        return 'Back'
    }
    # Ref: https://stackoverflow.com/questions/31603128/check-if-a-string-contains-any-substring-in-an-array-in-powershell
    elseif (($answer | %{$skusList.contains($_)}) -contains $true)
    {
        $SKU = $answer
        write-Host $SKU

    }
    else 
    {
        # Shouldn't get to here
        write-Host 'Invalid SKU string. Exiting'
        Exit
    }
    
}




$prompt = 'Checking whether Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName  +'" exists.'
write-Host $prompt
if ((util\check-hub  $GroupName $HubName  $Refresh) -eq $true)
{
    $prompt = 'Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" already exists. Returning'
    write-Host $prompt
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

