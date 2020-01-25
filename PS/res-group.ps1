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
$GroupStrnDataIndex =3


util\Heading '  G R O U P  '  DarkRed   White
$Prompt = ' Subscription :"' + $Subscription +'"'
write-Host $Prompt
$Prompt = 'Current Group :"' + $Current +'"'
write-Host $Prompt


if ($Refresh -eq $true)
{
    $global:GroupsStrn = null
}
[boolean]$skip = $false
if ($global:GroupsStrn -eq '')
{
    # This allows for previously returned empty string
    $skip = $true
}
If (([string]::IsNullOrEmpty($global:GroupsStrn ))  -and (-not $skip))
{   
    write-Host 'Getting Groups from Azure'
    $global:GroupsStrn =  az group list --subscription  $global:Subscription -o tsv | Out-String
}
If ([string]::IsNullOrEmpty($global:GroupsStrn ))
{
    $Prompt = 'No Groups found in Subscription "' + $Subscription + '".'
    write-Host $Prompt
    $Prompt ='Do you want to create a new Group for the Subscription "'+ $Subscription +'"?'
    $answer = util\yes-no-menu $Prompt 'N'
    if (($answer -eq 'Y') -OR ($answer -eq 'y'))
    {
	write-Host 'New Group'
        return 'New'
    }
    else {
        write-Host 'Returning'
        return 'Back'
    }
    return 'Back'
}

$GroupName = util\Show-Menu $global:GroupsStrn  '  G R O U P  ' 'N. New,D. Delete,B. Back'   $GroupStrnIndex  $GroupStrnDataIndex  3 40  $Current

write-Host $GroupName

If ([string]::IsNullOrEmpty($GroupName)) 
{
	write-Host 'Back'
    return 'Back'
}
esleif ($GroupName -eq 'Return')
{
	write-Host 'Back'
    return 'Back'
}
elseif ($GroupName -eq 'New')
{
    write-Host 'New'
    return 'New'
}
elseif ($GroupName -eq 'Delete')
{
    write-Host 'Delete'
    return 'Delete'
}
elseif ($GroupName -ne $global:GroupName)
{
    $global:GroupName =  $GroupName

    $global:HubsStrn=$null
    $global:DevicesStrn=$null
    $global:Hub = $null
    $global:Device=$null
}
elseif ($GroupName -eq 'Error')
{
	write-Host 'Error'
    return 'Error'
}
return $GroupName 