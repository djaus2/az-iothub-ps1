param (
    [string]$Subscription = '' ,
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

$GroupStrnIndex =3
if ($Refresh -eq $true)
{
    $global:GroupsStrn = null
}

util\Heading '  G R O U P  '  DarkRed   White
$Prompt =  'Subscription :"' + $Subscription +'"'
write-Host $Prompt
$Prompt = 'Current Group :"' + $Current +'"'
write-Host $Prompt


If ([string]::IsNullOrEmpty($global:GroupsStrn ))
{   
    write-Host 'Getting Groups from Azure'
    $global:GroupsStrn =  az group list --subscription  $global:Subscription -o tsv | Out-String
    $global:GotGroupsStrn =$true
}
If ([string]::IsNullOrEmpty($global:GroupsStrn ))
{
    $Prompt = 'No Groups found in Subscription "' + $Subscription + '".'
    write-Host $Prompt
    $Prompt ='Do you want to create a new Group for the Group "'+ $Subscription +'"?'
    $selectionList =@('Y','N','B')
    $answer = .\util\getchar-menu $Prompt   '[Y]es [N]o [B]ack' $selectionList  'N'
     if  (($answer -eq 'Y') -OR ($answer -eq 'y'))
    {
        return 'New'
    }
    elseif  (($answer -eq 'B') -OR ($answer -eq 'b'))
    {
        return ''
    }
    return ''
}
# $Subscription = util\Show-Menu $global:SubscriptionsStrn   'Subscription' 3 3 1 22  $Current
$GroupName = util\Show-Menu $global:GroupsStrn  '  G R O U P  ' 'N. New,D. Delete,B. Back'   $GroupStrnIndex  $GroupStrnIndex  3 40  $Current

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
    return 'Delete'
}
elseif ($GroupName -eq 'New')
{
    return 'New'
    write-Host 'New-Group'
    # $GroupName = invoke-expression -Command $PSScriptRoot\new-group.ps1
    $GroupName = util\new-group.ps1
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
if ($GroupName -ne $global:GroupName )
{
    $global:GroupName =  $GroupName

    $global:HubsStrn=$null
    $global:DevicesStrn=$null
    $global:Hub = $null
    $global:Device=$null
}

return $GroupName