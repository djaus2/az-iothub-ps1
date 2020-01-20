param (
    [string]$Subscription = '' ,
    [string]$Current='',
    [boolean]$Refresh=$false
)

$GroupStrnIndex =3
if ($Refresh -eq $true)
{
    $global:GroupsStrn = null
}

Clear-Host
write-Host ' AZURE IOT HUB SETUP: ' -NoNewline
write-Host '  G R O U P  '  -BackgroundColor DarkRed  -ForegroundColor White -NoNewline
write-Host ' using PowerShell'
write-Host ''


If ([string]::IsNullOrEmpty($global:GroupsStrn ))
{   
    write-Host 'Getting Groups from Azure'
    $global:GroupsStrn =  az group list --subscription  $global:Subscription -o tsv | Out-String
}
If ([string]::IsNullOrEmpty($global:GroupsStrn ))
{
    $Prompt = 'No Groups found in Subscription ' + $global:Subscription + '. Exiting.'
    write-Host $Prompt
    Exit
}
# $Subscription = utilities\Show-Menu $global:SubscriptionsStrn   'Subscription' 3 3 1 22  $Current
$GroupName = utilities\Show-Menu $global:GroupsStrn  '  G R O U P  '   $GroupStrnIndex  $GroupStrnIndex  3 40  $Current

write-Host $GroupName

if ($GroupName -eq 'Exit')
{
    write-Host 'Exiting.'
    exit
}
elseif ($GroupName -eq 'Back')
{
    Return
}
elseif ($GroupName -eq 'Delete')
{
    write-Host 'Delete. Exit for now.'
    exit
}
elseif ($GroupName -eq 'New')
{
    write-Host 'New-Group'
    # $GroupName = invoke-expression -Command $PSScriptRoot\new-group.ps1
    $GroupName = utilities\new-group.ps1
    if ($GroupName -eq 'Exit')
    {
        exit
    }
    elseif ($GroupName -eq 'Back')
    {
        Return 
    }
    elseif ($Group.Contains('Fail'))
    {
        exit
    }
    elseif ($GroupName.Contains('Exists'))
    {
        $temp = ($GroupName -split ' ')[0]
        $GroupName = $temp
        $prompt =  'Using existing group "' + $GroupName + '"'
        write-Host $prompt
    }
}
if ($GroupName -ne $global:Group )
{
    $global:GroupName =  $GroupName

    $global:HubsStrn=$null
    $global:DevicesStrn=$null
    $global:Hub = $null
    $global:Device=$null
}

return $GroupName