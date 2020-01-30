function Get-Subscription{
param (
   [string]$Current = '',
   [boolean]$Refresh = $false
)

    clear-host
    If ([string]::IsNullOrEmpty($global:DoneLogin)) 
    { 
        write-Host 'Have you run "az login" to access your accounts?'
        get-yesorno $false
        $answer = $global:retVal
        if  (-not $answer)
        {
            write-Host 'Openning Browser for Azure Login'
            az login  --output Table
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
# Assume there is atleast one subscription

    If  ([string]::IsNullOrEmpty($global:SubscriptionsStrn))
    {   
        write-Host 'Getting Subscriptions from Azure'
        if(-not([string]::IsNullOrEmpty($global:echoCommands)))
        {
            write-Host "Get Devices Command:"
            write-host "$global:SubscriptionsStrn  =  az account list  -o tsv | Out-String"
        }
        $global:SubscriptionsStrn  =  az account list  -o tsv | Out-String
    }
    If ([string]::IsNullOrEmpty($global:SubscriptionsStrn))
    {
        $prompt = 'No Subscriptions found. Have you run Az Login?'
        get-anykey $prompt 
        
    }

    parse-list $global:SubscriptionsStrn   '  S U B S C R I P T I O N   ' '' 3 3 1 22  $Current
    $answer = $global:retVal

    If ([string]::IsNullOrEmpty($answer)) 
    {
        write-Host 'Back'
        $answer =  'Back'
    }
    elseif ($answer -eq 'Back')
    {
        write-Host 'Back'
    }
    elseif ($answer -eq 'Return')
    {
        write-Host 'Back'
        $answer =  'Back'
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
    elseif ($answer -eq 'Error')
    {
        write-Host 'Error'
    }
    $global:retVal = $answer
}