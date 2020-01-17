param (
    [string]$GroupName=''
)
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
    $GroupName = show-menu $global:GroupsStrn  'Group'  3 3 3 40
    if ($GroupName -eq 'Exit')
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
if  (($answer -eq 'N') -OR ($answer -eq 'n'))
{
    return
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
    $prompt = 'Azure Resource Group "' + $GroupName +'" doesnt exist. Returning'
    write-Host $prompt
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
