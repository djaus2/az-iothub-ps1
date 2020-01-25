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




util\heading '  I o T  H U B  '  -BG DarkRed   -FG White
$Prompt =  'Subscription :"' + $Subscription +'"'
write-Host $Prompt
$Prompt = '       Group :"' + $GroupName +'"'
write-Host $Prompt
$Prompt = ' Current Hub :"' + $Current +'"'
write-Host $Prompt


if ($Refresh -eq $true)
{
    $global:HubsStrn = null
}
[boolean]$skip = $false
if  ($global:HubsStrn -eq '')
{
    # This allows for previously returned empty string
    $skip = $true
}
If  (([string]::IsNullOrEmpty($global:HubsStrn ))  -and (-not $skip))
{   
    write-Host 'Getting Hubs from Azure'
    $global:HubsStrn =  az iot hub list --resource-group  $GroupName  -o tsv | Out-String
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
    return 'Back'
}

$answer = util\Show-Menu $global:HubsStrn   '  H U B  '  'N. New,D. Delete,B. Back'  $HubStrnIndex $HubStrnDataIndex 2  22 $Current
write-Host $answer

If ([string]::IsNullOrEmpty($answer)) 
{
	write-Host 'Back'
    return 'Back'
}
elseif ($answer-eq 'Back')
{
    write-Host 'Back. Exit for now.'
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
elseif ($answer -ne $global:HubName)
{
    $global:HubName = $answer 
    $global:DevicesStrn=$null
    $global:Device=$null
    return $answer
}
elseif ($answer -eq 'Error')
{
	write-Host 'Error'
    return 'Error'
}
return $answer 