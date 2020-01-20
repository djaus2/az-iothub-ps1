param (
    [string]$Subscription = '' ,
    [string]$Group = '' ,
    [string]$Current='',
    [boolean]$Refresh=$false
)

$HubStrnIndex =3
$HubStrnDataIndex =3

if ($Refresh -eq $true)
{
    $global:HubsStrn = null
}

Clear-Host
write-Host ' AZURE IOT HUB SETUP: ' -NoNewline
write-Host '  I o T  H U B  '  -BackgroundColor DarkRed  -ForegroundColor White -NoNewline
write-Host ' using PowerShell'
write-Host ''

If  ([string]::IsNullOrEmpty($global:HubsStrn )) 
{   
    write-Host 'Getting Hubs from Azure'
    $global:HubsStrn =  az iot hub list --resource-group  $global:Group  -o tsv | Out-String
}
If ([string]::IsNullOrEmpty($global:HubsStrn ))
{
    $Prompt = 'No Hubs found in Group ' + $global:Group + '. Exiting.'
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

read-host ''
# $GroupName = utilities\Show-Menu $global:GroupsStrn  '  G R O U P  '   $GroupStrnIndex  $GroupStrnIndex  3 40  $Current
$global:Hub = utilities\Show-Menu $global:HubsStrn   '  H U B  ' $HubStrnIndex $HubStrnDataIndex 1 22 $Current
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
elseif ($Hub -ne $global:Hub)
{
    $global:HubName = $Hub 
    $global:DevicesStrn=$null
    $global:Device=$null
}
return $Hub 