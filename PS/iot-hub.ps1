#$global:SubscriptionsStrn = ''
#$global:Subscriptions = ''

function Show-Menu{
    param (
        [Parameter(Mandatory)]
        [string]$ListString, 
        [Parameter(Mandatory)]
        [string]$Index, 
        [Parameter(Mandatory)]
        [string]$Title,
        [string]$CurrentSelection=''
    )
    if ([string]::IsNullOrEmpty($ListString))
    {
        $prompt = 'No ' +$Title +'s found. Exiting'
        write-Host $prompt
        return 'Exit'
    }
    # clear-Host
    $hubst = $ListString
    $com =$hubst -split '\n'
    [int] $i=1
    write-Host ''
    $prompt ='Select a ' + $Title
    write-Host $prompt
    foreach ($j in $com) 
    {
        if ([string]::IsNullOrEmpty($j))
        {   
            write-Host ''
            $i++         
            break
        }
        $itemToList = ($j-split '\t')[$Index]
        [string]$prompt = [string]$i
        $prompt += '. '     
        $prompt +=  $itemToList
        if ( $itemToList -eq $CurrentSelection)
        {
            [string]$prompt = [string]$i
            $prompt += '. '   
            write-Host $prompt -NoNewline
            write-Host $itemToList -BackgroundColor Yellow -ForegroundColor Blue -NoNewline
            write-Host ' <-- Current Selection' -ForegroundColor DarkGreen
        }
        else 
        {
            write-Host $prompt
        }
        $i++
    }
    write-Host ''
    [string]$prompt = [string]$i
    $prompt += '. '
    $prompt +=  'Delete a ' + $Title
    write-Host $prompt
    $i++

    [string]$prompt = [string]$i
    $prompt += '. '
    $prompt +=  'New ' + $Title
    write-Host $prompt
    $i++
    [string]$prompt = [string]$i
    $prompt += '. '
    $prompt +=  'None '
    write-Host $prompt
    $i++
    [string]$prompt = [string]$i
    $prompt += '. '
    $prompt +=  'Back '
    write-Host $prompt
    $i++
    [string]$prompt = [string]$i
    $prompt += '. '
    $prompt +=  'Exit '
    write-Host $prompt
    
    [int]$selection =1
    $prompt ="Please make a (numerical) selection .. Or [Enter] if previous selection highlighted."
    do 
    {
        [int] $selection = 0
        $answer = read-host $prompt
        write-Host $answer
        if($answer -eq '-1')
        {
            # Just in case the user enters -1!
            $selection = 0
        }
        elseif (([string]::IsNullOrEmpty($answer)) -AND( $CurrentSelection -ne ''))
        {
            #Flag enter pressed so use $CurrentSelection
            $selection  = -1
        }
        elseif ([string]::IsNullOrEmpty($answer)) 
        {
            $selection  = 0
        }
        else 
        {
            $selection = [int]$answer
        }
        $prompt = "Please make a VALID selection."

    } until (`
         ($selection -gt 0) -and (($selection  -le  $i) `
            -and ($selection  -ne  ($i -5)) ) `
         -OR ($selection -eq -1))

    $output =''
    if ($selection -eq -1)
    {
        $output = $CurrentSelection
    }
    else 
    {
    
        if ($selection -eq $i)
        {
            $output='Exit'
        }
        elseif ($selection -eq $i-1)
        {
            $output='Back'
        }
        elseif ($selection -eq $i-2)
        {
            $output='None'
        }
        elseif ($selection -eq $i-3)
        {
            $output='New'
        }
        elseif ($selection -eq  $i-4)
        {
            $output = 'Delete'
        }
        else 
        {
            $com2 =($hubst -split '\n')[$selection-1]
            $output =  ($com2-split '\t')[$Index]   
        }
    }
    write-Host ''
    $promptFinal = $output + ' selected'
    write-Host $promptFinal

    return $output
}

Clear-Host
write-Host 'A Z U R E    I O T    H U B  S E T U P   using PowerShell'  -BackgroundColor Cyan  -ForegroundColor DarkGreen
write-Host ''
$answer = read-Host ' Have you run "az login" to access your accounts. Y/N (Default Y)'
if  (($answer -eq 'N') -OR ($answer -eq 'n'))
{
    exit
}



write-Host '=== Subscription ==='
write-Host ''
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
$Subscription = Show-Menu $global:SubscriptionsStrn 3  'Subscription' $global:Subscription
write-Host $Subscription


if ($Subscription -eq 'Exit')
{
    write-Host 'Exiting.'
    exit
}
elseif ($Subscription-eq 'Back')
{
    write-Host 'Back. Exit for now.'
    exit
}
elseif ($Subscription -eq 'New')
{
    write-Host 'New not an option for Subscriptions. Exiting.'
    exit
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

write-Host '=== Group ==='
write-Host ''
If ([string]::IsNullOrEmpty($global:GroupsStrn ))
{   
    write-Host 'Getting Groups from Azure'
    $global:GroupsStrn =  az group list --subscription  $global:Subscription -o tsv | Out-String
    # $Env:Groups = $GroupsStrn
}
If ([string]::IsNullOrEmpty($global:GroupsStrn ))
{
    $Prompt = 'No Groups found in Subscription ' + $global:Subscription + '. Exiting.'
    write-Host $Prompt
    Exit
}
$Group = Show-Menu $global:GroupsStrn 3  'Group'  $global:Group

write-Host $Group

if ($Group-eq 'Exit')
{
    write-Host 'Exiting.'
    exit
}
elseif ($Group-eq 'Back')
{
    write-Host 'Back. Exit for now.'
    exit
}
elseif ($Group-eq 'Delete')
{
    write-Host 'Delete. Exit for now.'
    exit
}
elseif ($Group -eq 'New')
{
    write-Host 'New-Group'
    $Group = invoke-expression -Command $PSScriptRoot\new-group.ps1
    if ($Group -eq 'Exit')
    {
        exit
    }
    elseif ($Group -eq 'Back')
    {
        exit
    }
    elseif ($Group.Contains('Fail'))
    {
        exit
    }
    elseif ($Group.Contains('Exists'))
    {
        $temp = ($Group -split ' ')[0]
        $Group = $temp
        $prompt =  'Using existing group "' + $Group + '"'
        write-Host $prompt
    }
}
if ($Group -ne $global:Group )
{
    $global:Group =  $Group

    $global:HubsStrn=$null
    $global:DevicesStrn=$null
    $global:Hub = $null
    $global:Device=$null
}





write-Host '=== IoT Hub ==='
write-Host ''

If ([string]::IsNullOrEmpty($global:HubsStrn ))
{   
    write-Host 'Getting Hubs from Azure'
    $global:HubsStrn =  az iot hub list --resource-group  $global:Group  -o tsv | Out-String
}
If ([string]::IsNullOrEmpty($global:HubsStrn ))
{
    $Prompt = 'No Hubs found in Group ' + $global:Group + '. Exiting.'
    write-Host $Prompt
    $Prompt ='OR Do you want to create a new Hub for the Group '+ $global:Group +'?'
    write-Host $Prompt
    $answer = read-host 'Y or y for new Hub. Exit otherwise.'
    if (($answer -eq 'Y') -OR ($answer -eq 'y'))
    {
        write-Host 'New Hub'
        exit
    }
    else {
        write-Host 'Exiting'
        exit
    }
}
$global:Hub = Show-Menu $global:HubsStrn 3  'Hub' $global:Hub
write-Host $Hub

if ($Hub -eq 'Exit')
{
    write-Host 'Exiting'
    exit
}
elseif ($Hub-eq 'Back')
{
    write-Host 'Back. Exit for now.'
    exit
}
elseif ($Hub -eq 'New')
{
    write-Host 'New-Group'
    exit
}
elseif ($Hub -ne $global:Hub)
{
    $global:Hub = $Hub

    $global:DevicesStrn=$null
    $global:Device=$null
}

write-Host '=== Device ==='
write-Host ''

If ([string]::IsNullOrEmpty($global:DevicesStrn ))
{   
    write-Host 'Getting Devices from Azure'
    $global:DevicesStrn =  az iot hub device-identity list  --hub-name $global:Hub -o tsv | Out-String
}
If ([string]::IsNullOrEmpty($global:DevicesStrn  ))
{
    $Prompt = 'No Devices found in Hub ' + $global:Hub + '. Exiting.'
    write-Host $Prompt
    $Prompt ='OR Do you want to create a new Device for the Hub '+ $global:Hub +'?'
    write-Host $Prompt
    $answer = read-host 'Y or y for new Device. Exit otherwise.'
    if (($answer -eq 'Y') -OR ($answer -eq 'y'))
    {
        write-Host 'New Device'
        exit
    }
    else {
        write-Host 'Exiting'
        exit
    } 
    Exit
}
$Device = Show-Menu $global:DevicesStrn 4  'Device' $global:Device
write-Host $Device

if ($Device -eq 'Exit')
{
    write-Host 'Exiting'
    exit
}
elseif ($Device-eq 'Back')
{
    write-Host 'Back. Exit for now.'
    exit
}
elseif ($Device -eq 'New')
{
    write-Host 'New-Device'
}
elseif ($Device -ne $global:Device)
{
    $global:Device = $Device
}