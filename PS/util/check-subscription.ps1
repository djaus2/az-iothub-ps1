param (
    [Parameter(Mandatory)]
    [string]$Subscription,
    [boolean]$Refresh=$false
)

$SubscriptionStrnIndex =3
if ($Refresh -eq $true)
{
    $Refresh
    $global:SubscriptionsStrn  = $null
}

$prompt = 'Checking whether Azure Subscription "'  + $Subscription + '" exits.'
write-Host $prompt
If ([string]::IsNullOrEmpty($global:SubscriptionsStrn ))
{   
    write-Host 'Getting Subscriptions from Azure'
    $global:SubscriptionsStrn =  az account list  -o tsv | Out-String
}
If ([string]::IsNullOrEmpty($global:SubscriptionsStrn ))
{
    $Prompt = 'No Subscriptions found in Subscription. Exiting.'
    write-Host $Prompt
    Exit
}
If (-not([string]::IsNullOrEmpty($global:SubscriptionsStrn )))
{   

    $lines =$global:SubscriptionsStrn -split '\n'
    foreach ($line in $lines) 
    {
        if ([string]::IsNullOrEmpty($line))
        {   
            continue
        }
        $itemToList = ($line -split '\t')[$SubscriptionStrnIndex]
        if ($itemToList -eq $Subscription)
        {
            $prompt = 'It exists'
            write-Host $prompt
            return $true
        }
    }
    $prompt = 'Subscription not found.'
    write-Host $prompt
    return $false
}
else 
{
    $prompt = 'No Subscriptions not found.'
    write-Host $prompt
    return false
}