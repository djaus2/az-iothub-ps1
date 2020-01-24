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
    return ''
}

$GroupStrnIndex =3
if ($Refresh -eq $true)
{
    $global:GroupsStrn  = $null
}

util\heading '  D E L E T E  G R O U P  '  DarkBlue  White

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
        $Prompt = 'No Groups found in Subscription. Exiting.'
        write-Host $Prompt
        Exit
    }
    
    $GroupName = util\Show-Menu $global:GroupsStrn  '  G R O U P  ' 'B. Back'   $GroupStrnIndex $GroupStrnIndex  3 36  ''

    #$GroupName =util\show-menu $global:GroupsStrn  'Group'  $GroupStrnIndex $GroupStrnIndex 3 40
    If ([string]::IsNullOrEmpty($GroupName ))
    {
        exit
    }
    elseif ($GroupName -eq 'Exit')
    {
        exit
    }
    elseif ($GroupName -eq 'Back')
    {
       return
    }

}
$prompt =  'Do you want to delete the group "' + $GroupName +  '" Y/N (Default N)'
$answer = read-Host $prompt
if ([string]::IsNullOrEmpty($answer))
{
    return $false
}
elseif  (($answer -eq 'N') -OR ($answer -eq 'n'))
{
    return $false
}


$prompt = 'Checking whether Azure Group "' + $GroupName  + '" exists.'
write-Host $prompt
if (  ( az group exists --name $GroupName   ) -eq $true)
{
    $prompt = 'Deleting Azure Resource Group "' + $GroupName + '"'
    write-Host $prompt
    az group delete --name $GroupName
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
    $prompt = 'It Failed'
    write-Host $prompt
    return 
}
else 
{
    $prompt = 'It was deleted.'
    write-Host $prompt
}
