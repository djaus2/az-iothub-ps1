param (
    [string]$Subscription='',
    [string]$GroupName='',
    [boolean]$Refresh=$false
)

If ([string]::IsNullOrEmpty($Subscription ))
{
    write-Host ''
    write-Host 'Need to select a Subscription first. Press any key to return.'
    $KeyPress = [System.Console]::ReadKey($true)
    return 'Back'
}

$GroupStrnIndex =3
if ($Refresh -eq $true)
{
    $global:GroupsStrn  = $null
}

util\heading '  D E L E T E  G R O U P  '  DarkRed  White

# Need a group name
if ([string]::IsNullOrEmpty($GroupName))
{
    If ([string]::IsNullOrEmpty($global:GroupsStrn ))
    {   
        write-Host 'Getting Groups from Azure'
        $global:GroupsStrn =  az group list -o tsv | Out-String
        # $global:GroupsStrn =  az group list --subscription  $global:Subscription -o tsv | Out-String
    }
    If ([string]::IsNullOrEmpty($global:GroupsStrn ))
    {
        # $Prompt = 'No Groups found in Subscription ' + $global:Subscription + '. Exiting.'
        $Prompt = 'No Groups found in Subscription. press any key to return.'
        write-Host $Prompt
    	$KeyPress = [System.Console]::ReadKey($true
        return 'Back'
    }
    $GroupName = menu\Show-Menu $global:GroupsStrn  '  G R O U P  ' 'B. Back'   $GroupStrnIndex $GroupStrnIndex  3 36  ''

    If ([string]::IsNullOrEmpty($GroupName ))
    {
        return 'Back'
    }
    elseif ($GroupName -eq 'Back')
    {
        return 'Back'
    }
    elseif ($GroupName -eq 'Error')
    {
       return 'Error'
    }
}

$prompt =  'Do you want to delete the group "' + $GroupName +  '"'
$answer = menu\yes-no $prompt 'N'
if ([string]::IsNullOrEmpty($answer))
{
    return 'Back'
}
elseif  (($answer -eq 'N') -OR ($answer -eq 'n'))
{
    return 'Back'
}

$global:GroupName= $null
$global:GroupsStrn= $null
$global:HubName= $null
$global:HubsStrn=$null
$global:DeviceName = null
$global:DevicesStrn=$null

if (  ( util\check-hub $GroupName $HubName  $Refresh ) -eq $true)
{
    $prompt = 'Deleting Azure Resource Group "' + $GroupName + '"'
    write-Host $prompt
    az group delete --name $GroupName -o tsv | Out-String
}
else 
{
    $prompt = 'Azure Resource Group "' + $GroupName +'" doesnt exist. Press and key to return.'
    write-Host $prompt
    $KeyPress = [System.Console]::ReadKey($true)
    return
}

$prompt = 'Checking whether Azure Group "' + $GroupName   +'" was deleted.'
write-Host $prompt
if (  ( az group exists --name $GroupName   ) -eq $true)
{
    $prompt = 'It Failed.  Press any key to return.'
    write-Host $prompt
    $KeyPress = [System.Console]::ReadKey($true)
    return  'Error'
}
else 
{
    $prompt = 'It was deleted.  Press [Enter] to return.'
    write-Host $prompt
    $KeyPress = [System.Console]::ReadKey($true)
    return 'Back'
}
