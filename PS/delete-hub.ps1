param (
    [string]$Subscription,
    [string]$GroupName,
    [string]$HubName='',
    [boolean]$Refresh=$false
)

If ([string]::IsNullOrEmpty($Subscription ))
{
    write-Host ''
    $prompt = 'Need to select a Subscription first.'
    menu\any-key $prompt
    return 'Back'
}
elseIf ([string]::IsNullOrEmpty($GroupName ))
{
    write-Host ''
    $prompt = 'Need to select a Group first.'
    menu\any-key $prompt
    return 'Back'
}

$HubStrnIndex =3
if ($Refresh -eq $true)
{
    $global:HubsStrn  = $null
}

util\heading '  D E L E T E  I o T  H U B  '   DarkRed  White

# Need a Hub name
if ([string]::IsNullOrEmpty($HubName))
{
  
    If ([string]::IsNullOrEmpty($global:HubsStrn ))
    {   
        write-Host 'Getting Hubs from Azure'
        $global:HubsStrn =  az IoT Hub list --resource-group  $GroupName -o tsv | Out-String
    }
    If ([string]::IsNullOrEmpty($global:HubsStrn ))
    {
        $Prompt = 'No Hubs found in Subscription.'
        menu\any-key $prompt
        return 'Back'
    }

    $answer = menu\parse-list $global:HubsStrn  'Hub'  $HubStrnIndex  $HubStrnIndex 1 22
    
    If ([string]::IsNullOrEmpty($answer ))
    {
        return 'Back'    
    }
    elseif ($answer -eq 'Back')
    {
        return 'Back'
    }
    elseif ($answer -eq 'Error')
    {
       return 'Error'
    }
    $HubName = $answer
}

$prompt =  'Do you want to delete the Hub "' + $HubName +  '"'
$answer = menu\yes-no $prompt 'N'
if ([string]::IsNullOrEmpty($answer))
{
    return 'Back'
}
elseif  (($answer -eq 'N') -OR ($answer -eq 'n'))
{
    return 'Back'
}

$global:HubName = $null
$global:HubsStrn = $null
$global:DeviceName = $null
$global:DevicesStrn = $null

if (  ( util\check-hub $GroupName $HubName  $Refresh ) -eq $true)
{
    $prompt = 'Deleting Azure Resource Hub "' + $HubName + '" in Group "' + $GroupName +'"'
    write-Host $prompt
    az iot hub delete --name $HubName   --resource-group $GroupName -o tsv | Out-String
}
else 
{
    $prompt = 'Azure Resource Hub "' + $HubName +'" doesnt exist. Press any key to return.'
    menu\any-key $prompt
    return 'Back'
}

$prompt = 'Checking whether Azure Hub "' + $HubName   +'" was deleted.'
write-Host $prompt

if (  ( util\check-hub $GroupName $HubName  $True   ) -eq $true)
{
    $prompt = 'It Failed.'
    menu\any-key $prompt
    return  'Error'
}
else 
{
    $prompt = 'It was deleted.'
    menu\any-key $prompt
    return 'Back'
}
