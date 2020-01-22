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
    $selectionList =@('Y','N','B')

    $answer = .\utilities\getchar-menu ' Have you run "az login" to access your accounts?'  '[Y]es [N]o [B]ack' $selectionList  'Y'
    # $answer = read-Host ' Have you run "az login" to access your accounts. Y/N X to Return. (Default Yes)'
    if  (($answer -eq 'N') -OR ($answer -eq 'n'))
    {
        az login
        [Console]::ResetColor()
    }
    elseif  (($answer -eq 'B') -OR ($answer -eq 'b'))
    {
        return ''
    }
    elseif  (($answer -eq 'Y') -OR ($answer -eq 'y'))
    {
        write-Host 'Continuing'
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

If  ([string]::IsNullOrEmpty($global:SubscriptionsStrn))
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
$Subscription = utilities\smq $global:SubscriptionsStrn   '  S U B S C R I P T I O N   ' 3 3 1 22  $Current

If ([string]::IsNullOrEmpty($Subscription)) 
{
    $Subscription=$Current
    $global:returnVal = ''
    return ''
}
elseif ($Subscription -eq 'New')
{
    return 'New'
}
elseif ($Subscription -eq 'New')
{
    return 'Delete'
}
elseif (($Subscription -ne $global:Subscription) -or ([string]::IsNullOrEmpty($global:Subscription)) )
{
    $global:Subscription = $Subscription
    $global:GroupsStrn =$null
    $global:HubsStrn=$null
    $global:DevicesStrn=$null
    $global:Group = $null
    $global:Hub = $null
    $global:Device=$null
}

return $Subscription