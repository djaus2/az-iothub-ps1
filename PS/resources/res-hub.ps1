function Get-Hub{
param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$Current='',
    [boolean]$Refresh=$false
)
show-heading '  I o T   H U B  '  2
$Prompt =  ' Subscription :"' + $Subscription +'"'
write-Host $Prompt
$Prompt = ' Current Group :"' + $GroupName +'"'
write-Host $Prompt
$Prompt = '   Current Hub :"' + $Current +'"'
write-Host $Prompt

    If ([string]::IsNullOrEmpty($Subscription ))
    {
        write-Host ''
        $prompt =  'Need to select a Subscription first.'
        write-host $prompt
        get-anykey 
        $global:DeviceName =  'Back'
        return
    }
    elseIf ([string]::IsNullOrEmpty($GroupName ))
    {
        write-Host ''
        $prompt = 'Need to select a Group first'
        write-host $prompt
        get-anykey
        $global:DeviceName =  'Back'
        return
    }

    # $HubStrnIndex =3
    # $HubStrnDataIndex =3










    $HubName = $Current
    do{

        if ($Refresh -eq $true)
        {
            $global:HubsStrn = $null
            $Refresh = $false
        }

        if ($null -eq $HubName)
        {
            $HubName =''
        }
        $Current=$HubName
    If  ([string]::IsNullOrEmpty($global:HubsStrn )) 
    {   
        write-Host 'Getting Hubs from Azure'
        if(-not([string]::IsNullOrEmpty($global:echoCommands)))
        {
            write-Host "Get Hubs Command:"
            write-host "$global:HubsStrn =  az iot hub list --resource-group  $GroupName  -o tsv | Out-String "
        }
        $global:HubsStrn =  az iot hub list --resource-group  $GroupName  -o tsv | Out-String
    }
    If ([string]::IsNullOrEmpty($global:HubsStrn ))
    {
        $Prompt = 'No Hubs found in Group "' + $GroupName + '".'
        write-Host $Prompt
        $global:HubsStrn ='Empty'
    }

        show-heading '  I O T   H U B   '  2
        $Prompt = '   Subscription :"' + $Subscription +'"'
        write-Host $Prompt
        $Prompt = '  Current Group :"' + $GroupName +'"'
        write-Host $Prompt
        $Prompt = '    Current Hub :"' + $Current +'"'
        write-Host $Prompt


        $options = 'N. New,R. Refresh'
        If (-not [string]::IsNullOrEmpty($Current )){
            $options = "$options,U. Unselect,D. Delete"
        }

        $options="$options,B. Back"
    parse-list $global:HubsStrn   '  H U B  '  $options  $HubStrnIndex $HubStrnDataIndex 2  22 $Current
    $answer= $global:retVal
    write-Host $answer

    If ([string]::IsNullOrEmpty($answer)) 
    {
        write-Host 'Back'
        $answer = 'Back'
    }
    elseif ($answer-eq 'Back')
    {
        write-Host 'Back'
    }
    elseif ($answer -eq 'Error')
    {
        write-Host 'Error'

    }
    elseif ($answer -eq 'Unselect')
	{
	    $Current=$null
        write-Host 'CLEAR_CURRENT_HUB'
        $global:HubName = $null
	$HubName=$null   
        $global:DevicesStrn=$null
        $global:DeviceName=$null
	}
    elseif ($answer -eq 'New')
    {
        write-Host 'New'
        new-Hub $Subscription $GroupName
        $answer = $global:retVal
        if ($answer -eq 'Done')
        {
            $answer  = $global:HubName
            $HubName=$answer
            $global:DevicesStrn=$null
            $global:DeviceName=$null
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
        Remove-Hub  $Subscription $GroupName $HubName
        $answer = $global:retVal
        if ($answer -eq 'Done')
        {
            $HubName=$null
	    $global:HubName=$null
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
    elseif ($answer -ne $global:HubName)
    {
        $global:HubName = $answer 
	    $HubName=$answer
        $global:DevicesStrn=$null
        $global:DeviceName=$null
        if ($global:doneItem)
            {
                $answer='Back'             
        }
    	$global:doneItem = $null
    }

    } while (($answer -ne 'Back') -and ($answer -ne 'Error'))
    $global:retval = $answer 
}