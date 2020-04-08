function Remove-DPS{
param (
    [Parameter(Mandatory)]
    [string]$Subscription  ,
    [Parameter(Mandatory)]
    [string]$GroupName  ,
    [string]$DPSName = '' ,
    [boolean]$Refresh=$false
)

    $DPSStrnIndex =3
    $DPSStrnDataIndex =5 

    . ("$global:ScriptDirectory\Util\Check-DPS.ps1")

    If ([string]::IsNullOrEmpty($Subscription ))
    {
        write-Host ''
        $prompt =  'Need to select a Subscription first.'
        get-anykey $prompt
        $global:retVal = 'Back'
        return
    }
    elseIf ([string]::IsNullOrEmpty($GroupName ))
    {
        write-Host ''
        $prompt = 'Need to select a Group first.'
       get-anykey $prompt
       $global:retVal = 'Back'
       return
    }

    
    # Force refresh of list of Devices
    $Refresh = $true
    if ($Refresh -eq $true)
    {
        $global:DPSStrn  = $null
    }

    show-heading '  D E L E T E  D P S '   4

    # Need a DPS name
    if ([string]::IsNullOrEmpty($DPSName))
    {
    
        If ([string]::IsNullOrEmpty($global:DPSStrn )) 
        {   
            write-Host 'Getting IoT Hub DPSs from Azure for the Group'
            if(-not([string]::IsNullOrEmpty($global:echoCommands)))
            {
                write-Host "Get DPS Command:"
                write-host "$global:DPSStrn =  az iot dps list --subscription "$Subscription" --resource-group $GroupName -o tsv | Out-String "
                get-anykey
            }
            $global:DPSStrn =  az iot dps list --subscription "$Subscription" --resource-group $GroupName -o tsv | Out-String

        }
        If ([string]::IsNullOrEmpty($global:DPSStrn ))
        {
            $Prompt = 'No DPSs found in Device'
           get-anykey $prompt
           $global:retVal = 'Back'
           return
        }
        parse-list $global:DPSStrn  'DPS' 'B. Back' $DPSStrnIndex  $DPSStrnIndex  1 22
        $answer = $global:retVal 
        If ([string]::IsNullOrEmpty($answer ))
        {
            $global:retVal = 'Back'
            return
        }

        elseif ($answer -eq 'Back')
        {
            return
        }
        elseif ($answer -eq 'Error')
        {
            return
        }
        $DPSName = $answer
    }
    else {
        # Would've been selected from menu or just created so DevicesStrn should be current
    }


    $prompt =  'Do you want to delete the DPS "' + $DPSName +  '"'
    write-Host $prompt
   get-yesorno $false
   $answer = $global:retVal
    if (-not $answer)
    {
        $global:retVal = 'Back'
        return
    }
    $global:DPSName = $null
    $global:DPSStrn = $null

    $results = check-DPS $Subscription $GroupName $DPSName
    if (  $global:retVal )
    {
        $prompt = "Deleting Azure IOT Hub DPS  $DPSName in Group $GroupName in Subscription $Subscription"
        write-Host $prompt
        $global:echoCommands="Yes"
        if(-not([string]::IsNullOrEmpty($global:echoCommands)))
        {
            write-Host "Delete DPS Command:"
            write-Host "az iot dps delete --name $DPSName --resource-group $GroupName --subscription "$Subscription" -o tsv | Out-String"
            get-anykey
        }
        $global:echoCommands=$null
        az iot dps delete --name $DPSName --resource-group $GroupName --subscription "$Subscription" -o tsv | Out-String


        $prompt =  "Checking whether IoT Hub DPS  $DPSName in Group  $GroupName  in Subscription $Subscription was deleted."
        write-Host $prompt
        $global:DPSStrn = $null
        $result=check-dps $Subscription $GroupName $DPSName 
        if ( $global:retVal) 
        {
            $prompt = 'It Failed.'
            get-anykey $prompt
            $global:retVal =  'Error'
        }
        else 
        {
            $prompt = 'It was deleted.'
            get-anykey $prompt
            $global:retVal = 'Back'
        }
    }
    else 
    {
        $prompt = "IoT Hub DPS $DeviceName doesnt exist."
        get-anykey $prompt
        $global:retVal = 'Back'
    }
}
