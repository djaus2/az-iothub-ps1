param (
    [string]$Subscription = '' ,
    [string]$GroupName='',
    [string]$HubName='',
    [string]$SKU ='',
    [boolean]$Refresh=$false
)



Clear-Host
write-Host ' AZURE IOT HUB SETUP:  N E W  H U B  using PowerShell '  -BackgroundColor DarkBlue  -ForegroundColor White
write-Host ''


# Need a group name
if ([string]::IsNullOrEmpty($GroupName))
{
    do
    {
        $prompt = 'Enter Resource Group Name, X to exit/return'
        $answer= read-Host $prompt
        $answer = $answer.Trim()
        write-Host $answer
        
    } until (-not ([string]::IsNullOrEmpty($answer)))
    if ($answer.ToUpper() -eq 'X')
    {
        write-Host 'Returning'
        return
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
        return false
    }
    elseif (($answer | %{$skusList.contains($_)}) -contains $true)
    {
        $SKU = $answer
        write-Host $SKU

    }
    else 
    {
        write-Host 'Invalid SKU string. Returning'
        return false
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
        return
    }
    $HubName = $answer
}


# Subscription is  optional
if (([string]::IsNullOrEmpty($Subscription)) -or ($true))
{

    if ((check-hub  $GroupName $HubName  $Refresh) -eq $true)
    {
        $prompt = 'Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" already exists. Returning'
        write-Host $prompt
        return false
    }
    

    $prompt = 'Creating new Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" using SKU "' +$SKU +'"'
    write-Host $prompt

    az iot hub create --name $HubName   --resource-group $GroupName --sku $SKU
   
    $prompt = 'Checking whether Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" was created.'
    write-Host $prompt
    if ((check-hub  $GroupName $HubName  $true) -eq $true)
    {
        $prompt = 'Hub was created.'
        write-Host $prompt
        $global:HubName = $HubName
    }
    else 
    {
        $prompt = 'Hub not created.'
        write-Host $prompt
        $global:HubName = null
    }
}
