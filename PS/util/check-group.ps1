param (
    [Parameter(Mandatory)]
    [string]$GroupName,
    [boolean]$Refresh=$false
)

$GroupsStrnIndex =3
if ($Refresh -eq $true)
{
    $Refresh
    $global:GroupsStrn  = $null
}

$prompt = 'Checking whether Azure Group "'  + $GroupName + '" exits.'
write-Host $prompt
If ([string]::IsNullOrEmpty($global:GroupsStrn ))
{   
    write-Host 'Getting Groups from Azure'
    $global:GroupsStrn =  az group list -o tsv | Out-String
}
If ([string]::IsNullOrEmpty($global:GroupsStrn ))
{
    $Prompt = 'No Groups found in Subscription. Exiting.'
    write-Host $Prompt
    Exit
}
If (-not([string]::IsNullOrEmpty($global:GroupsStrn )))
{   

    $lines =$global:GroupsStrn -split '\n'
    foreach ($line in $lines) 
    {
        if ([string]::IsNullOrEmpty($line))
        {   
            continue
        }
        $itemToList = ($line -split '\t')[$GroupsStrnIndex]
        if ($itemToList -eq $GroupName)
        {
            $prompt = 'It exists'
            write-Host $prompt
            return $true
        }
    }
    $prompt = 'Group not found.'
    write-Host $prompt
    return $false
}
else 
{
    $prompt = 'No Groups not found.'
    write-Host $prompt
    return false
}