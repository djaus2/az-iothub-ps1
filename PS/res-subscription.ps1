param (
   [string]$Current = '',
   [boolean]$Refresh = $false
)

Clear-Host
write-Host ' AZURE IOT HUB SETUP: ' -NoNewline
write-Host '  S U B S C R I P T I O N  '  -BackgroundColor DarkRed  -ForegroundColor White -NoNewline
write-Host ' using PowerShell'
write-Host ''

If ([string]::IsNullOrEmpty($global:DoneLogin)) 
{ 
    $selectionList =@('Y','N','X')
    
    $global:ReturnValue ='_'
    YNXMenu ' Have you run "az login" to access your accounts?'  '[Y]es [N]o E[x]it' $selectionList  'Y'
    $answ  = $global:ReturnValue
    write-Host $answ
    read-host
    $answer = read-Host ' Have you run "az login" to access your accounts. Y/N X to Return. (Default Yes)'
    if  (($answer -eq 'N') -OR ($answer -eq 'n'))
    {
        az login
    }
    elseif  (($answer -eq 'X') -OR ($answer -eq 'x'))
    {
        return
    }
    elseif  (($answer -eq 'Y') -OR ($answer -eq 'y'))
    {
        write-Host 'Continuing1'
    }
    elseif ([string]::IsNullOrEmpty($answer))
    {
        write-Host 'Continuing'
    }
    $global:DoneLogin = 'DoneLogin'
}

if ($Refresh -eq $true)
{
    $global:SubscriptionsStrn = $null
}

If ([string]::IsNullOrEmpty($global:SubscriptionsStrn)) 
{   
    write-Host 'Getting Subscriptions from Azure'
    $global:SubscriptionsStrn  =  az account list  -o tsv | Out-String
}
If ([string]::IsNullOrEmpty($global:SubscriptionsStrn))
{
    $Prompt = 'No Subscriptions found. Have you run Az Login? Exiting.'
    write-Host $Prompt
    Exit
}
# $HubName = show-menu $global:HubsStrn  'Hub'  $HubStrnIndex  $HubStrnIndex 1 22
# x$DeviceName = utilities\show-menu $global:DeicessStrn  'Device'  $DeviceStrnIndex  $DeviceStrnIndex  1 22
$Subscription = utilities\Show-Menu $global:SubscriptionsStrn   '  S U B S C R I P T I O N   ' 3 3 1 22  $Current

write-Host $Subscription


if ($Subscription -eq 'Exit')
{
    write-Host 'Exiting.'
    exit
}
elseif ($Subscription-eq 'Back')
{
    return
}
elseif ($Subscription -eq 'New')
{
    write-Host 'New not an option for Subscriptions. Exiting.'
    return
}
elseif ($Subscription -ne $global:Subscription)
{
    $global:Subscription = $Subscription

    $global:GroupsStrn =$null
    $global:HubsStrn=$null
    $global:DevicesStrn=$null
    $global:Group = $null
    $global:Hub = $null
    $global:Device=$null
}
return