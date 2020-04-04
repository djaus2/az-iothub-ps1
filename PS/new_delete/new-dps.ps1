function New-DPS{
param (
    [Parameter(Mandatory)]
    [string]$Subscription ,
    [Parameter(Mandatory)]
    [string]$GroupName,
    [string]$DPSName ='',
    [Nullable[boolean]]$EdgeEnabled=$false,
    [boolean]$Refresh=$false
)

. ("$global:ScriptDirectory\Util\Check-dps.ps1")


show-heading '  N E W  D P S   '   3

    If ([string]::IsNullOrEmpty($Subscription ))
    {
        write-Host ''
        $prompt = 'Need to select a Subscription first.'
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
    elseIf (-not ([string]::IsNullOrEmpty($DPSName )))
    {
        write-Host ''
        $prompt = "Do you want to use $DPSName for the name of the new DPS?"
        get-yesorno $true $prompt
        if (-not $global:retVal)
        {
            write-host "New"
            $DeviceName =''
        }
    }

    if ($Refresh)
    {
        $global:DPSStrn=null
    }



    # Need a DPS name
    if ([string]::IsNullOrEmpty($DPSName))
    {
        $answer = get-name 'DPS'
        if ($answer.ToUpper() -eq 'Back')
        {
            write-Host 'Returning'
            get-anykey
            $global:retVal = 'Back'
            return
        }
        $DPSName = $answer
    }







    # Is it edge enabled. Not required for SDK Quickstarts
    if ([string]::IsNullOrEmpty($EdgeEnabled))
    {
        $EdgeEnabled = $false

        $prompt = 'Do you want it to be Edge Enabled? Not required for IoT Hub SDK Quickstarts.'
        $answer= get-yesno $false $prompt
        If ($answer)
        {
            $EdgeEnabled = true
        }     
    }

    $result = check-dps $Subscription $GroupName  $DPSName 
    if ($global:retVal )
    {
        $prompt = 'Azure IoT DPS "' + $DPSName  +'" in Group "' + $GroupName + '" already exists.'
        get-anykey $prompt
        $global:retVal =  'Exists'
        return
    }

    $global:DPSStrn = $null
    $global:DPSName  = $null

    write-Host ''
    $prompt = "Creating new Azure IoT Hub DPS $DPSName in Group  $GroupName in Subscription  $Subscription with SKU S1 and unit = $global:DPSunits " + '(Set $global:DPSunits)'
    write-Host $prompt
    write-Host ''


    if(-not([string]::IsNullOrEmpty($global:echoCommands)))
    {
        write-Host "Create DPS Command:"
        write-Host "az iot dps create --name $DPSName  --subscription $Subscription --resource-group $GroupName  --sku S1 --unit $global:DPSunits  -o Table"
    }
    az iot dps create --name $DPSName --subscription $Subscription  --resource-group $GroupName  --sku S1  --unit $global:DPSunits -o Table

    


    $prompt = 'Checking whether Azure IoT Hub DPS "' + $DPSName + '"  in Group "' + $GroupName + '" in Subscription "' + $Subscription +' was created.'
    write-Host $prompt
    
    # Need to refresh the list of dps
    $global:DPSStrn = $null
    $result = check-dps $Subscription  $GroupName $DPSName 
    if ($global:retVal)
    {
        $prompt = "DPS $DPSName was created."
        get-anykey $prompt
        $global:DPSName=$DPSName
        $global:retVal = $DPSName
    }
    else 
    {
        #If not found after trying to create it, must be inerror
        $prompt = 'DPS not created.'
        get-anykey $prompt 'Exit'
        $global:retVal =  'Error'
    }
}


