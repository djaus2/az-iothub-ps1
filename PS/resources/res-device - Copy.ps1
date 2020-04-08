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
        get-anykey $prompt
        $global:DeviceName =  'Back'
        return
    }

    # $DeviceStrnIndex =5
    # $DeviceStrnDataIndex =5



    show-heading '  D E V I C E   '  2
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
        $global:DevicesStrn = null
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
        if(-not([string]::IsNullOrEmpty($global:echoCommands)))
        {
            write-Host "Get Devices Command:"
            write-host "$global:DevicesStrn =  az iot hub device-identity list  --hub-name $HubName --resource-group $GroupName -o tsv | Out-String "
            get-anykey
        }
        $global:DevicesStrn =  az iot hub device-identity list  --hub-name $HubName --resource-group $GroupName -o tsv | Out-String
    }
    If ([string]::IsNullOrEmpty($global:DevicesStrn ))
    {
        $Prompt = 'No Devices found in Hub "' + $HubName + '".'
        write-Host $Prompt
        $Prompt ='Do you want to create a new Device for the Hub "'+ $Hub +'"?'
        write-Host $prompt
        get-yesorno $true
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

    $DeviceName = $Current
    do{
        $Current=$DeviceName
        show-heading '  D E V I C E   '  2
        $Prompt = '   Subscription :"' + $Subscription +'"'
        write-Host $Prompt
        $Prompt = '          Group :"' + $GroupName +'"'
        write-Host $Prompt
        $Prompt = '            Hub :"' + $HubName +'"'
        write-Host $Prompt
        $Prompt = ' Current Device :"' + $Current +'"'
        write-Host $Prompt

        $options = 'N. New'
        If (-not [string]::IsNullOrEmpty($Current )){
            $options = "$options,U. Unselect,D. Delete"
        }

        $options="$options,B. Back"

        parse-list $global:DevicesStrn   '  D E V I C E  ' $options  $DeviceStrnIndex $DeviceStrnDataIndex 1  22 $Current
        $answer =  $global:retVal

        If ([string]::IsNullOrEmpty($answer)) 
        {
            write-Host 'Back'
            $answer =  'Back'
        }
        elseif ($answer -eq 'Back')
        {
            write-Host 'Back'
        }
        elseif ($answer -eq 'Unselect')
        {
            $Current=$null
            $global:DeviceName = $null 
            $DeviceName =$null
        }
        elseif ($answer -eq 'New')
        {
            New-Device $Subscription $GroupName $HubName
            $DeviceName= $global:DeviceName
        }
        elseif ($answer -eq 'Delete')
        {
            Remove-Device  $Subscription $GroupName $HubName $DeviceName
            $DeviceName = $null
            $global:DeviceName = $null 
        }
        elseif ($answer -ne $global:DeviceName)
        {

            $global:DeviceName = $answer 
            $DeviceName = $answer
            if ($global:doneItem)
            {
                $answer='Back'             
            }
            $global:doneItem = $null
        }
        elseif ($answer -eq 'Error')
        {
            write-Host 'Error'
        }
    } while (($answer -ne 'Back') -and ($answer -ne 'Error'))
    $global:retval = $answer 
}