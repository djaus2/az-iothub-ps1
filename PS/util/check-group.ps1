function Check-Group{
param (
    [Parameter(Mandatory)]
    [string]$Subscription,
    [Parameter(Mandatory)]
    [string]$GroupName
)

    $GroupsStrnIndex =3

    $prompt = 'Checking whether Azure Group "'  + $GroupName + '" exists.'
    write-Host $prompt
    If ([string]::IsNullOrEmpty($global:GroupsStrn ))
    {   
        write-Host 'Getting Groups from Azure'
        $global:GroupsStrn =  az group list -o tsv | Out-String
    }
    If ([string]::IsNullOrEmpty($global:GroupsStrn ))
    {
        $Prompt = 'No Groups found in Subscription..'
        write-Host $Prompt
        return $false
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
}