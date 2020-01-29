function Do-Group{
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


util\Heading '  G R O U P  '  DarkBlue   White
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
    $answer = menu\yes-no $Prompt 'N'
    if ($answer )
    {
	write-Host 'New Group'
        return 'New'
    }
    else {
        write-Host 'Returning'
        return 'Back'
    }
}

$answer= menu\parse-list $global:GroupsStrn  '  G R O U P  ' 'N. New,D. Delete,B. Back'   $GroupStrnIndex  $GroupStrnDataIndex  3 36  $Current
write-Host $prompt

If ([string]::IsNullOrEmpty($answer)) 
{
	write-Host 'Back'
    return 'Back'
}
elseif ($answer -eq 'Back')
{
	write-Host 'Back'
    return 'Back'
}
elseif ($answer -eq 'New')
{
    write-Host 'New'
    return 'New'
}
elseif ($answer -eq 'Delete')
{
    write-Host 'Delete'
    return 'Delete'
}
elseif ($answer -ne $global:GroupName)
{
    $global:GroupName =  $answer

    $global:HubsStrn=$null
    $global:DevicesStrn=$null
    $global:Hub = $null
    $global:Device=$null
    return $answer
}
elseif ($answer -eq 'Error')
{
	write-Host 'Error'
    return 'Error'
}
return $answer 
}