function New-Group{
param (
    [Parameter(Mandatory)]
    [string]$Subscription = '' ,
    [string]$GroupName='',
    [string]$Location=''
)
    . ("$global:ScriptDirectory\Util\Check-Group.ps1")
    
    $GroupeName=$null

    If ([string]::IsNullOrEmpty($Subscription ))
    {
        write-Host ''
        $prompt =  'Need to select a Subscription first.'
        get-anykey $prompt
        return ''
    }

    # Force Refresh
    $Refresh = $true
    if ($Refresh)
    {
        $global:Groups=$null
    }


    util\heading '  N E W  G R O U P  '   DarkGreen  White 



    # Need a group name
    if ([string]::IsNullOrEmpty($GroupName))
    {
        $answer = util\get-name 'Resource Group'
        if ($answer -eq 'Back')
        {
            write-Host 'Returning'
            return 'Back'
        }
        $GroupName = $answer
    }


    # Need a location
    # Get list from Azure
    if ([string]::IsNullOrEmpty($Location))
    {
        if ([string]::IsNullOrEmpty($global:LocationsStrn))
        {
            $global:LocationsStrn = az account list-locations  -o tsv | Out-String
        }
        if ([string]::IsNullOrEmpty($global:LocationsStrn))
        {
            $prompt = 'Error getting Resource Group Location List.'
            $global:retVal = 'Error'
            get-anykey $prompt 'Exit'
            return
        }
        parse-list $global:LocationsStrn  '  L O C A T I O N  ' 'B. Back'   0 4  3 40  ''
        $result = $global:retVal

        $prompt = 'Location "' + $result +'" returned'
        write-Host $prompt

        if ([string]::IsNullOrEmpty($result))
        {
            $global:retVal = 'Back'
	    return
        }
        elseif ($result -eq 'Back')
        {
            $global:retVal = 'Back'
	    return
        }
        elseif ($result -eq 'Error')
        {
            $global:retVal = 'Error'
	    return
        }
        elseif ($result -eq 'Exit')
        {
	   $global:retVal ='Exit'
            return
        }
        $Location = $result
    }



    $prompt = 'Checking whether Azure Group "' + $GroupName  + '" in Subscription "' + $Subscription +'" exists.' + '" at location "' + $Location +'"'
    write-Host $prompt
    $global:GroupsStrn = $null
    if (check-group $Subscription  $GroupName ) {
        $prompt = 'Azure Resource Group "' + $GroupName +'" already exists.'
        get-anykey $prompt
        $global:retVal =  'Exists'
        return
    }
    $global:GroupName = $null
    $global:GroupsStrn = $null
    $global:HubName = $null
    $global:HubsStrn = $null
    $global:DevicesStrn=$null
    $global:DeviceName=$null
    $prompt = 'Creeating new Azure Resource Group "' + $GroupName +'"'
    write-Host $prompt
    
    if(-not([string]::IsNullOrEmpty($global:echoCommands)))
    {
        write-Host "Create Device Command:"
        write-Host "az group create --name $GroupName --location $Location --subscription $Subscription  -o Table"
    }
    az group create --name $GroupName --location $Location --subscription $Subscription  -o Table 

    $prompt = 'Checking whether Azure Group "' + $GroupName  + '" in Subscription "' + $Subscription +'" was created.'
    write-Host $prompt

    # Need to refresh the list of groups
    $global:GroupsStrn = $null
    if (check-group $Subscription  $GroupName ) {
        $prompt = 'Group was created.'
        get-anykey $prompt
        $global:GroupName = $GroupName
        $global:retVal = $GroupName
    }
    else{ 
        #If not found after trying to create it, must be inerror
        $prompt = 'Group not created.'
        get-anykey $prompt 'Exit'
        $global:retVal =  'Error'
    }
}
