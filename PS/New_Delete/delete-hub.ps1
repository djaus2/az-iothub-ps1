function Remove-Hub{
param (
    [Parameter(Mandatory)]
    [string]$Subscription,
    [Parameter(Mandatory)]
    [string]$GroupName,
    [string]$HubName,
    [boolean]$Refresh=$false
)

    $HubStrnIndex =3
    $HubStrnDataIndex =3

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
    $Refresh=$true
    if ($Refresh -eq $true)
    {
        $global:HubsStrn  = $null
    }

    util\heading '  D E L E T E  I o T  H U B  '   DarkRed  White

    # Need a Hub name
    if ([string]::IsNullOrEmpty($HubName))
    {

        If ([string]::IsNullOrEmpty($global:HubsStrn ))
        {   
            write-Host 'Getting Hubs from Azure'
            if(-not([string]::IsNullOrEmpty($global:echoCommands)))
            {
                write-Host "Get Hubs Command:"
                write-host "$global:HubsStrn =  az IoT Hub list --resource-group  $GroupName -o tsv | Out-String"
            }
            $global:HubsStrn =  az IoT Hub list --resource-group  $GroupName -o tsv | Out-String
        }
        If ([string]::IsNullOrEmpty($global:HubsStrn ))
        {
            $Prompt = 'No Hubs found in Subscription.'
        get-anykey $prompt
            $global:retVal = 'Back'
            return
        }


        parse-list $global:HubsStrn  'Hub'  $HubStrnIndex  $HubStrnDataIndex 1 22
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
        $HubName = $answer
    }
    else {
        # Would've been selected from menu or just created so HubsStrn should be current
    }

    $prompt =  'Do you want to delete the Hub "' + $HubName +  '"'
    write-Host $prompt
    get-yesorno $false
    $answer = $global:retVal
    if (-not $answer)
    {
        $global:retVal = 'Back'
        return
    }


    $global:HubName = $null
    $global:HubsStrn = $null
    $global:DeviceName = $null
    $global:DevicesStrn = $null

    if ( util\check-hub $GroupName $HubName )
    {
    	$prompt = 'Deleting Azure Resource Hub "' + $HubName + '" in Group "' + $GroupName +'"'
    	write-Host $prompt
	    if(-not([string]::IsNullOrEmpty($global:echoCommands)))
	    {
	        write-Host "Delete Device Command:"
	        write-Host "az iot hub delete --name $HubName   --resource-group $GroupName -o Tableg"
        }
    	az iot hub delete --name $HubName   --resource-group $GroupName -o Table


    	$prompt = 'Checking whether Azure Hub "' + $HubName   +'" was deleted.'
    	write-Host $prompt
    	$global:DevicesStrn = $null
    	if ( util\check-hub $GroupName $HubName )
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
        $prompt = 'Azure IOT Hub Device "' + $DeviceName +'" doesnt exist.'
        get-anykey $prompt
        $global:retVal = 'Back'
    }   
}
