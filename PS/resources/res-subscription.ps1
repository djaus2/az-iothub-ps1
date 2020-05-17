function Get-Subscription{
param (
   [string]$Current = '',
   [boolean]$Refresh = $false
)

show-heading  -Prompt '  S U B S C R I P T I O N  '  2

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




    show-heading  -Prompt '  S U B S C R I P T I O N  '  2
    $Prompt =  'Current Subscription :"' + $Current +'"'
    write-Host $Prompt
    if ($Refresh -eq $true)
    {
        $global:SubscriptionsStrn = $null
    }
    elseif(-not([string]::IsNullOrEmpty($current)))
    {
        get-yesorno $True "Do you want to use the Current Subscription? (Y/N)"
        $answer = $global:retVal
        if  ( $answer)
        {
            $global:retVal = 'Back'
            return $current
        }
    }
# Assume there is at least one subscription
$global:SubscriptionsStrn  =  ''

    If  ([string]::IsNullOrEmpty($global:SubscriptionsStrn))
    {   
        write-Host 'Getting Subscriptions from Azure'
        if(-not([string]::IsNullOrEmpty($global:echoCommands)))
        {
            write-Host "Get Devices Command:"
            write-host "$global:SubscriptionsStrn  =  az account list  -o tsv | Out-String"
            get-anykey
        }
        $global:SubscriptionsStrn  =  ''
        $lines1 =@()
        $lines2 = {$lines1}.Invoke()
        $ListString=  az account list  -o tsv | Out-String
        $lines= $ListString.Split("`r`n",[System.StringSplitOptions]::RemoveEmptyEntries)
        foreach ($j in $lines) 
        {
            $line = $j.Trim()

            if ([string]::IsNullOrEmpty($line))
            {          
                continue
            }
            else {       
                $itemToList = ($line-split '\t')[$SubscriptionIDIndex]
                # Remove Subscriptions that are inactive
                if ($itemToList.Trim() -eq 'False'){
                    continue
                }
                $lines2.Add( $line )
            }
        }
        $global:SubscriptionsStrn   = $lines2 | out-string
    }
    If ([string]::IsNullOrEmpty($global:SubscriptionsStrn))
    {
        $prompt = 'No Subscriptions found. Have you run Az Login?'
        get-anykey $prompt 
        return 'Back'
        
    }

    parse-list $global:SubscriptionsStrn   '  S U B S C R I P T I O N   ' 'B. Back'   $SubscriptionStrnIndex  $SubscriptionStrnDataIndex  1 22  $Current
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
        az account set  --subscription  $global:Subscription
        $global:GroupsStrn =$null
        $global:HubsStrn=$null
        $global:DevicesStrn=$null
        $global:GroupName = $null
        $global:HubName = $null
        $global:Device=$null
        $global:DPSStrn= $null
        $global:DPSName=$null
    }
    elseif ($answer -eq 'Error')
    {
        write-Host 'Error'
    }
    $global:retVal = $answer
}