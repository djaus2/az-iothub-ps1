param (
    [string]$Subscription,
    [string]$GroupName,
    [string]$HubName='',
    [boolean]$Refresh=$false
)

If ([string]::IsNullOrEmpty($Subscription ))
{
    write-Host ''
    write-Host 'Need to select a Subscription first. Press any key to return.'
    $KeyPress = [System.Console]::ReadKey($true)
    return 'Back'
}
elseIf ([string]::IsNullOrEmpty($GroupName ))
{
    write-Host ''
    write-Host 'Need to select a Group first. Press any key to return.'
    $KeyPress = [System.Console]::ReadKey($true)
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
  
    If ( ([string]::IsNullOrEmpty($global:HubsStrn )) -or $Refresh)
    {   
        write-Host 'Getting Hubs from Azure'
        $global:HubsStrn =  az IoT Hub list --resource-group  $GroupName -o tsv | Out-String
    }
    If ([string]::IsNullOrEmpty($global:HubsStrn ))
    {
        $Prompt = 'No Hubs found in Subscription. Returning.'
        write-Host $Prompt
        return false
    }

    $HubName = menu\show-menu $global:HubsStrn  'Hub'  $HubStrnIndex  $HubStrnIndex 1 22
    if ($HubName -eq 'Exit')
{
        return 'Exit'
    }
    elseif ($HubName -eq 'Back')
    {
       return 'Back'
    }
    elseif ($HubName -eq 'Error')
    {
       return 'Error'
    }
    elseif ([string]::IsNullOrEmpty($HubName))
    {
        $prompt = 'Hub Name is blank or null. Returning'
        write-Host $prompt
        return $false
    }

}

$prompt =  'Do you want to delete the Hub "' + $HubName +  '" Y/N (Default N)'
$answer = read-Host $prompt
if ([string]::IsNullOrEmpty($answer))
{
    return 'Back'
}
elseif  (($answer -eq 'N') -OR ($answer -eq 'n'))
{
    return 'Backe
}

$global:HubName= null


if (  ( util\check-hub $GroupName $HubName  $Refresh ) -eq $true)
{
    $prompt = 'Deleting Azure Resource Hub "' + $HubName + '" in Group "' + $GroupName +'"'
    write-Host $prompt
    az iot hub delete --name $HubName   --resource-group $GroupName -o tsv | Out-String
}
else 
{
    $prompt = 'Azure Resource Hub "' + $HubName +'" doesnt exist. Press [Enter] to return.'
    read-Host $prompt
    return 'Back'
}

$prompt = 'Checking whether Azure Hub "' + $HubName   +'" was deleted.'
write-Host $prompt
if (  ( uti\check-hub $GroupName $HubName  $True   ) -eq $true)
{
    $prompt = 'It Failed.  Press [Enter] to return.'
    read-Host $prompt
    return  $false
}
else 
{
    $prompt = 'It was deleted.  Press [Enter] to return.'
    read-Host $prompt
    return 'Back'
}
