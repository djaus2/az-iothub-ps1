param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$Current='',
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

$HubStrnIndex =3
$HubStrnDataIndex =3

if ($Refresh -eq $true)
{
    $global:HubsStrn = null
}


util\heading '  I o T  H U B  '  -BG DarkRed   -FG White
$Prompt =  'Subscription :"' + $Subscription +'"'
write-Host $Prompt
$Prompt = '       Group :"' + $GroupName +'"'
write-Host $Prompt
$Prompt = ' Current Hub :"' + $Current +'"'
write-Host $Prompt

If  ([string]::IsNullOrEmpty($global:HubsStrn )) 
{   
    write-Host 'Getting Hubs from Azure'
    $global:HubsStrn =  az iot hub list --resource-group  $GroupName  -o tsv | Out-String
    $global:GotGroupsStrn =$true
}
If ([string]::IsNullOrEmpty($global:HubsStrn ))
{
    $Prompt = 'No Hubs found in Group "' + $GroupName + '".'
    write-Host $Prompt
    $Prompt ='Do you want to create a new Hub for the Group "'+ $GroupName +'"?'
    $answer = util\yes-no-menu $Prompt 'N'
    if (($answer -eq 'Y') -OR ($answer -eq 'y'))
    {
        write-Host 'New Hub'
        return 'New'
    }
    else {
        write-Host 'Returning'
        return 'Back'
    }
}


# $GroupName = util\Show-Menu $global:GroupsStrn  '  G R O U P  ' 'N. New,D. Delete,B. Back'   $GroupStrnIndex  $GroupStrnIndex  3 40  $Current

$HubName = util\Show-Menu $global:HubsStrn   '  H U B  '  'N. New,D. Delete,B. Back'  $HubStrnIndex $HubStrnDataIndex 2  22 $Current
write-Host $HubName

if ($HubName-eq 'Back')
{
    write-Host 'Back. Exit for now.'
    retrun 'Back'
}
elseif ($HubName -eq 'New')
{
    write-Host 'New'
    return 'New'
}
elseif ($HubName -eq 'Delete')
{
    write-Host 'Delete'
    return 'Delete'
}
elseif ($HubName -ne $global:HubName)
{
    $global:HubName = $HubName 
    $global:DevicesStrn=$null
    $global:Device=$null
}
return $HubName 