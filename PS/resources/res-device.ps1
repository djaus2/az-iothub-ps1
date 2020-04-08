function Get-Device{
param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$Current='',
    [boolean]$Refresh=$false
)

show-heading '  D E V I C E   '  2
$Prompt = '    Subscription :"' + $Subscription +'"'
write-Host $Prompt
$Prompt = '   Current Group :"' + $GroupName +'"'
write-Host $Prompt
$Prompt = '     Current Hub :"' + $HubName +'"'
write-Host $Prompt
$Prompt = '  Current Device :"' + $Current +'"'
write-Host $Prompt

    If ([string]::IsNullOrEmpty($Subscription ))
    {
        write-Host ''
        $prompt =  'Need to select a Subscription first.`n'
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
        $prompt =  'Need to select a Hub first.'
        write-host $prompt
        get-anykey 
        $global:DeviceName =  'Back'
        return
    }

    # $DeviceStrnIndex =5
    # $DeviceStrnDataIndex =5






    $DeviceName = $Current
    do{
    if ($Refresh -eq $true)
    {
        $global:DevicesStrn = null
	$Refresh = $false
    }
    
    if ($null -eq $DeviceName)
    {
            $HubName =''
    }
   
    $Current =$DeviceName	
    If  ([string]::IsNullOrEmpty($global:DevicesStrn  )) 
    {   
        write-Host 'Getting Devices from Azure'
        if(-not([string]::IsNullOrEmpty($global:echoCommands)))
        {
            write-Host "Get Devices Command:"
            write-host "$global:DevicesStrn =  az iot hub device-identity list  --hub-name $HubName --resource-group $GroupName -o tsv | Out-String "
        }
        $global:DevicesStrn =  az iot hub device-identity list  --hub-name $HubName --resource-group $GroupName -o tsv | Out-String
    }
    If ([string]::IsNullOrEmpty($global:DevicesStrn ))
    {
        $Prompt = 'No Devices found in Hub "' + $HubName + '".'
        write-Host $Prompt
        $global:DeviceStrn ='Empty'
    }


        show-heading '  D E V I C E   '  2
        $Prompt = '   Subscription :"' + $Subscription +'"'
        write-Host $Prompt
        $Prompt = '          Group :"' + $GroupName +'"'
        write-Host $Prompt
        $Prompt = '            Hub :"' + $HubName +'"'
        write-Host $Prompt
        $Prompt = ' Current Device :"' + $Current +'"'
        write-Host $Prompt

        $options = 'N. New.R. Refresh'
        If (-not [string]::IsNullOrEmpty($Current )){
            $options = "$options,U. Unselect,D. Delete"
        }

        $options="$options,B. Back"

        parse-list $global:DevicesStrn   '  D E V I C E  ' $options  $DeviceStrnIndex $DeviceStrnDataIndex 1  22 $Current
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
        elseif ($answer -eq 'Unselect')
        {
            $Current=$null
	    write-Host 'CLEAR_CURRENT_DEVICE'
            $global:DeviceName = $null 
            $DeviceName =$null
        }
        elseif ($answer -eq 'New')
        {
		 write-Host 'New'
            New-Device $Subscription $GroupName $HubName
	        $answer = $global:retVal
	        if ($answer -eq 'Done')
	        {
	            $answer  = $global:DeviceName
	            $DeviceName=$answer
	        }
	        elseif($answer -eq 'Exists')
	        {
	        }
	        elseif($answer -eq 'Back')
	        {
	        }
	        elseif($answer -eq 'Error')
	        {
	        }
        }
        elseif ($answer -eq 'Delete')
        {
	 write-Host 'Delete'
            Remove-Device  $Subscription $GroupName $HubName $DeviceName
	        $answer = $global:retVal
	        if ($answer -eq 'Done')
	        {
		    $global:DeviceName=$null
	            $DeviceName=$null
	        }
	        elseif($answer -eq 'Exists')
	        {
	        }
	        elseif($answer -eq 'Back')
	        {
	        }
	        elseif($answer -eq 'Error')
	        {
	        }
        }
	    elseif ($answer -eq 'Refresh')
	    {
	        write-Host 'Refresh'
	        $Refresh = $true
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