param (
    [string]$Subscription='',
    [string]$GroupName='',
    [boolean]$Refresh=$false
)

If ([string]::IsNullOrEmpty($Subscription ))
{
    write-Host ''
    $prompt= 'Need to select a Subscription first.'
    menu\any-key $prompt
    return 'Back'
}

$GroupStrnIndex =3
if ($Refresh -eq $true)
{
    $global:GroupsStrn  = $null
}

util\heading '  D E L E T E  G R O U P  '  DarkRed  White

# Need a Group name
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
        $Prompt = 'No Groups found in Subscription.'
        menu\any-key $prompt
        return 'Back'
    }
      
    $answer = menu\parse-list $global:GroupsStrn  '  G R O U P  ' 'B. Back'   $GroupStrnIndex $GroupStrnIndex  3 36  ''
    
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
    $GroupName = $answer
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
    $prompt = 'Azure Resource Group "' + $GroupName +'" doesnt exist.'
    menu\any-key $prompt
    return 'Back'
}

$prompt = 'Checking whether Azure Group "' + $GroupName   +'" was deleted.'
write-Host $prompt
if (  ( az group exists --name $GroupName   ) -eq $true)
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
