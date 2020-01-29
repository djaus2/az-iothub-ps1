function Get-Device{
param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$Current='',
    [boolean]$Refresh=$false
)

    If ([string]::IsNullOrEmpty($Subscription ))
    {
        write-Host ''
        $prompt =  'Need to select a Subscription first.'
        get-anykey $prompt
        $global:DeviceName =  'Back'
        return
    }
    elseIf ([string]::IsNullOrEmpty($GroupName ))
    {
        write-Host ''
        $prompt = 'Need to select a Group first.'
        get-anykey $prompt
        $global:DeviceName =  'Back'
        return
    }
    elseIf ([string]::IsNullOrEmpty($HubName ))
    {
        write-Host ''
        prompt =  'Need to select a Hub first.'
        $global:DeviceName =  'Back'
        return
    }

    $DeviceStrnIndex =5
    $DeviceStrnDataIndex =5



    util\heading '  D E V I C E   '  -BG DarkBlue   -FG White
    $Prompt = '   Subscription :"' + $Subscription +'"'
    write-Host $Prompt
    $Prompt = '          Group :"' + $GroupName +'"'
    write-Host $Prompt
    $Prompt = '            Hub :"' + $HubName +'"'
    write-Host $Prompt
    $Prompt = ' Current Device :"' + $Current +'"'
    write-Host $Prompt

    if ($Refresh -eq $true)
    {
        $global:DeviceNamesStrn = null
    }
    [boolean]$skip = $false
    if  ($global:DevicesStrn -eq '')
    {
        # This allows for previously returned empty string
        $skip = $true
    }
    If  (([string]::IsNullOrEmpty($global:DevicesStrn  ))  -and (-not $skip))
    {   
        write-Host 'Getting Devices from Azure'
        $global:DevicesStrn =  az iot hub device-identity list  --hub-name $HubName -o tsv | Out-String
    }
    If ([string]::IsNullOrEmpty($global:DevicesStrn ))
    {
        $Prompt = 'No Devices found in Hub "' + $HubName + '".'
        write-Host $Prompt
        $Prompt ='Do you want to create a new Device for the Hub "'+ $Hub +'"?'
        write-Host $prompt
        get-yesorno $false
        read-Host $global:retVal
        $answer =  $global:retVal
        if ($answer)
        {
            write-Host 'New Device'
            $global:retVal =  'New'
        }
        else {
            write-Host 'Returning'
            $global:retVal = 'Back'
        }
        return
    }

    parse-list $global:DevicesStrn   '  D E V I C E  '  'N. New,D. Delete,B. Back'  $DeviceStrnIndex $DeviceStrnDataIndex 1  22 $Current
    $answer =  $global:retVal
    write-Host $answer

    If ([string]::IsNullOrEmpty($answer)) 
    {
        write-Host 'Back'
        $answer =  'Back'
    }
    elseif ($answer -eq 'Back')
    {
        write-Host 'Back'
    }
    elseif ($answer -eq 'New')
    {
        write-Host 'New'
    }
    elseif ($answer -eq 'Delete')
    {
        write-Host 'Delete'
    }
    elseif ($answer -ne $global:DeviceName)
    {
        $global:DeviceName = $answer 
    }
    elseif ($answer -eq 'Error')
    {
        write-Host 'Error'
    }
    $global:retval = $answer 
}