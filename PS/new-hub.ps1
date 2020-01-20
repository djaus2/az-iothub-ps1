param (
    [string]$Subscription = '' ,
    [string]$GroupName='',
    [string]$HubName='',
    [string]$SKU ='',
    [boolean]$Refresh=$false
)



Clear-Host
write-Host ' AZURE IOT HUB SETUP: ' -NoNewline
write-Host '  N E W  I o T  H U B  '  -BackgroundColor DarkBlue  -ForegroundColor White -NoNewline
write-Host ' using PowerShell'
write-Host ''

$global:HubName = $null

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


$prompt = 'Checking whether Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName  +'" exists.'
write-Host $prompt
if ((utilities\check-hub  $GroupName $HubName  $Refresh) -eq $true)
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
    $prompt = 'Hub was created.'
    write-Host $prompt
    $global:HubName = $HubName
    return $HubName
}
else 
{
    $prompt = 'Hub not created. Exiting'
    write-Host $prompt
    exit
}

