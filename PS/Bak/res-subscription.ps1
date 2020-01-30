function do-subscription{
param (
   [string]$Current = '',
   [boolean]$Refresh = $false
)

    If ([string]::IsNullOrEmpty($global:DoneLogin)) 
    { 
        get-yesorno $false ' Have you run "az login" to access your accounts?'
        $answer = $global:retVal
        if  (-not $answer)
        {
            write-Host 'Openning Browser for Azure Login'
            az login | Out-String
            [Console]::ResetColor()
        }
        else 
        {
            write-Host 'Continuing'
        }
        $global:DoneLogin = 'DoneLogin'
    }


    util\heading  -Prompt '  S U B S C R I P T I O N  '   -BG DarkBlue  -FG White
    $Prompt =  'Current Subscription :"' + $Current +'"'
    write-Host $Prompt
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
        $Prompt = 'No Subscriptions found. Have you run Az Login? Press [Return] to return.'
        read-Host $Prompt
        
    }

    parse-list $global:SubscriptionsStrn   '  S U B S C R I P T I O N   ' 'B. Back' 3 3 1 22  $Current
    $answer = $global:retVal
    write-Host $answer

    If ([string]::IsNullOrEmpty($answer)) 
    {

    }
    elseif ($answer -eq 'Return')
    {

    }
    elseif ($answer -eq 'Back')

    }
    elseif ($answer -eq 'Error')
    {

    }
    elseif ($answer -ne $global:Subscription) 
    {
        $global:Subscription = $answer
        $global:GroupsStrn =$null
        $global:HubsStrn=$null
        $global:DevicesStrn=$null
        $global:Group = $null
        $global:Hub = $null
        $global:Device=$null
    }
}