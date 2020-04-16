function Get-DPS{
param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$Current = '',
    [string]$DeviceName='',
    [boolean]$Refresh=$false
)



show-heading '  D E V I C E  P R O V I S I O N I N G  S E R V I C E (DPS)  '  2
$Prompt = '   Subscription :"' + $Subscription +'"'
write-Host $Prompt
$Prompt = '          Group :"' + $GroupName +'"'
write-Host $Prompt
$Prompt = '            Hub :"' + $HubName +'"'
write-Host $Prompt
$Prompt = ' Current Device :"' + $DeviceName +'"'
write-Host $Prompt
$Prompt = '    Current DPS :"' + $Current +'"'
write-Host $Prompt

    try{
    . ("$global:ScriptDirectory\util\set-envvar.ps1")
    } catch {
        Write-Host "Error while loading supporting Env Vars PowerShell Scripts" 
        Write-Host $_
    }

    If ([string]::IsNullOrEmpty($Subscription ))
    {
        write-Host ''
        $prompt =  'Need to select a Subscription first.'
        write-host $prompt
        get-anykey 
        $global:DPS =  'Back'
        return
    }
    elseIf ([string]::IsNullOrEmpty($GroupName ))
    {
        write-Host ''
        $prompt = 'Need to select a Group first.'
        write-host $prompt
        get-anykey 
        $global:DPS =  'Back'
        return
    }

    $Location =""
    If (-not [string]::IsNullOrEmpty($global:HubsStrn ))
    {
        try{
        $Location =  ($global:HubsStrn -split '\t')[2] 
        }
        catch {
            $Location = ''
        }
    }


    $DPSStrnIndex =3
    $DPSStrnDataIndex =5





   $DPSName=$Current
    do{

    if ($Refresh -eq $true)
    {
        $global:DPSStrn = $null
	$Refresh=$false
    }

  if ($null -eq $DPSName)
        {
            $DPSName =''
        }
        $Current=$DPSName

    If  ([string]::IsNullOrEmpty($global:DPSStrn )) 
    {   
        write-Host 'Getting DPS from Azure'
        if(-not([string]::IsNullOrEmpty($global:echoCommands)))
        {
            write-Host "Get DPS Command:"
            write-host "$global:DPSStrn =  az iot dps list --resource-group $GroupName  -o tsv | Out-String "
            get-anykey
        }
        $global:DPSStrn =  az iot dps list --resource-group $GroupName   -o tsv | Out-String
    }


    If ([string]::IsNullOrEmpty($global:DPSStrn ))
    {
        $Prompt = 'No DPS found in Group "' + $GroupName + '".'
        write-Host $Prompt
        $global:DPSStrn='EMPTY'
    }
        show-heading '  D E V I C E  P R O V I S I O N I N G  S E R V I C E  (DPS)'  2
        $Prompt = '   Subscription :"' + $Subscription +'"'
        write-Host $Prompt
        $Prompt = '  Current Group :"' + $GroupName +'"'
        write-Host $Prompt
        $Prompt = '    Current Hub :"' + $HubName +'"'
        write-Host $Prompt
        $Prompt = ' Current Device :"' + $DeviceName +'"'
        write-Host $Prompt
        $Prompt = '    Current DPS :"' + $Current +'"'
        write-Host $Prompt

        $options = 'N. New,R. Refresh'
        If (-not [string]::IsNullOrEmpty($Current )){
            $options = "$options,S. Show,U. Unselect,D. Delete"
            If (-not [string]::IsNullOrEmpty($HubName ))
            {
                If (-not [string]::IsNullOrEmpty($env:IOTHUB_CONN_STRING_CSHARP ))
                {
                    If (-not [string]::IsNullOrEmpty($global:HubsStrn ))
                    {

                        $options = "$options,G. Generate Env Vars for Hub Connection,C. Connect Current Hub to DPS,Z. Disconnect Current Hub from DPS" 
                    }
                }
            }
        }
        $options="$options,B. Back"

        parse-list $global:DPSStrn   '  D P S  '  $options $DPSStrnIndex $DPSStrnIndex 2  22 $Current
        $answer= $global:retVal
	write-host $answer

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
        elseif ($answer-eq 'Unselect')
        {
            $Current=$null
            $global:DPSName = $null 
            $DPSName =$null
        }

        elseif ($answer -eq 'New')
        {
		write-Host 'New'
	        New-DPS $Subscription $GroupName
	        $answer = $global:retVal
	        if ($answer -eq 'Done')
	        {
	            $answer  = $global:DPSName
	            $DPSName=$answer
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
            	Remove-DPS  $Subscription $GroupName $DPSName
	        $answer = $global:retVal
	        if ($answer -eq 'Done')
	        {
	            $DPSName=$null
		    $global:DPSName=$null
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
        elseif ($answer -eq 'Show')
        {
            show-dps $Current
        }
	elseif ($answer -eq 'Connect')
        {
            $DPSName = $Current
            $global:DPSName = $Current 
            $global:retVal =  $Current
            write-host "About to run (Press [Enter] to continue):"
            read-host "az iot dps linked-hub create --dps-name $DPSName --resource-group $GroupName --connection-string $env:IOTHUB_CONN_STRING_CSHARP  --location $location -o table"
            az iot dps linked-hub create --dps-name $DPSName --resource-group $GroupName --connection-string $env:IOTHUB_CONN_STRING_CSHARP  --location $location  -o table
            show-dps $Current
        }
        elseif ($answer -eq 'Disconnect')
        {
            $DPSName = $Current
            $global:DPSName = $Current 
            $global:retVal =  $Current
            $ExtenedHubName = "$HubName.azure-devices.net"
            write-host "About to run (Press [Enter] to continue):"
            read-host "az iot dps linked-hub delete --dps-name $DPSName --resource-group $GroupName --linked-hub $ExtenedHubName -o table"
            $ExtenedHubName = "$HubName.azure-devices.net"
            az iot dps linked-hub delete --dps-name $DPSName --resource-group $GroupName --linked-hub $ExtenedHubName -o table
            show-dps $Current
        } 
        elseif ($answer -eq 'Generate')
        {
            set-env $Subscription $GroupName $HubName $DeviceName
        } 
        elseif ($answer -ne $global:DPSName)
        {
            $global:DPSName = $answer 
            $global:retVal =  $answer
            $DPSName =$answer
            if ($global:doneItem)
            {
                $answer='Back'              
            }
            $global:doneItem = $null
        }

    } while (($answer -ne 'Back') -and ($answer -ne 'Error'))

    $global:retval = $answer
}

function show-dps{
param (
    [string]$DPSName = ''
)
    If (-not [string]::IsNullOrEmpty($DPSName ))
    {
        write-Host ''
        write-Host "$DPSName (Wait):"
        az iot dps show --name $DPSName -o table
        write-Host ''
        write-Host "Connected Hubs (Wait):"
        $query = az iot dps show --name $DPSName -o json | Out-String | ConvertFrom-Json
        foreach ($dps in $query) {$dps.Properties.iotHubs.name}
    }
    write-Host ''
    get-anykey
}