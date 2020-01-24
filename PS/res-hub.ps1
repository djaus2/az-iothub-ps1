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
    read-Host $global:HubsStrn
    write-Host 'Getting Hubs from Azure'
    $global:HubsStrn =  az iot hub list --resource-group  $GroupName  -o tsv | Out-String
}
If ([string]::IsNullOrEmpty($global:HubsStrn ))
{
    $Prompt = 'No Hubs found in Group ' + $:Group + '.'
    write-Host $Prompt
    $Prompt ='OR Do you want to create a new Hub for the Group '+ $global:Group +'?'
    write-Host $Prompt
    $answer = read-host 'Y or y for new Hub. Exit otherwise.'
    if (($answer -eq 'Y') -OR ($answer -eq 'y'))
    {
        write-Host 'New Hub'
        exit
    }
    else {
        write-Host 'Exiting'
        exit
    }
}


# $GroupName = util\Show-Menu $global:GroupsStrn  '  G R O U P  ' 'N. New,D. Delete,B. Back'   $GroupStrnIndex  $GroupStrnIndex  3 40  $Current

$global:Hub = util\Show-Menu $global:HubsStrn   '  H U B  '  'N. New,D. Delete,B. Back'  $HubStrnIndex $HubStrnDataIndex 1  22 $Current
write-Host $Hub

if ($Hub -eq 'Exit')
{
    write-Host 'Exiting'
    exit
}
elseif ($Hub-eq 'Back')
{
    write-Host 'Back. Exit for now.'
    exit
}
elseif ($Hub -eq 'New')
{
    write-Host 'New-Group'
    exit
}
elseif ($Hub -ne $global:HubName)
{
    $global:HubName = $Hub 
    $global:DevicesStrn=$null
    $global:Device=$null
}
return $Hub 