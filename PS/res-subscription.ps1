param (
   [string]$Current = '',
   [boolean]$Refresh = $false
)

util\heading  -Prompt '  S U B S C R I P T I O N  '   -BG DarkRed  -FG White
$Prompt =  'Current Subscription :"' + $Current +'"'
write-Host $Prompt


If ([string]::IsNullOrEmpty($global:DoneLogin)) 
{ 
    $selectionList =@('Y','N','B')

    $answer = .\util\getchar-menu ' Have you run "az login" to access your accounts?'  '[Y]es [N]o [B]ack' $selectionList  'Y'
    # $answer = read-Host ' Have you run "az login" to access your accounts. Y/N X to Return. (Default Yes)'
    if  (($answer -eq 'N') -OR ($answer -eq 'n'))
    {
        write-Host 'Openning Browser for Azure Login'
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
[boolean]$skip = $false
if  ($global:SubscriptionsStrn -eq '')
{
    # This allows for previously returned empty string
    $skip = $true
}
If  (([string]::IsNullOrEmpty($global:SubscriptionsStrn)) -and (-not $skip))
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
# x$DeviceName = util\show-menu $global:DeicessStrn  'Device'  $DeviceStrnIndex  $DeviceStrnIndex  1 22
$Subscription = util\show-menu $global:SubscriptionsStrn   '  S U B S C R I P T I O N   ' 'B. Back' 3 3 1 22  $Current

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