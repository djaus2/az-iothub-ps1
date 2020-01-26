param (
    [string]$Subscription = '' ,
    [string]$GroupName='',
    [string]$Location='',
    [boolean]$Refresh=$false
)

If ([string]::IsNullOrEmpty($Subscription ))
{
    write-Host ''
    write-Host 'Need to select a Subscription first. Press any key to return.'
    $KeyPress = [System.Console]::ReadKey($true)
    return ''
}

if ($Refresh)
{
	$global:Groups=null
	$global:Locations = $null
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
            write-Host 'Error getting Resource Group Location List. Exiting'
            return 'Error'
        }
        [string]$result = menu\Show-Menu $global:LocationsStrn  '  L O C A T I O N  ' 'B. Back'   0 4  3 40  ''

        $Location = $result 
        $prompt = 'Location "' +$result +'" returned'

    write-Host $prompt

    if ([string]::IsNullOrEmpty($Location))
    {
        return 'Back'
    }
    elseif ($Location -eq 'Back')
    {
        return 'Back'
    }
}



# Subscription is  optional
if ([string]::IsNullOrEmpty($Subscription)) 
{
    $prompt = 'Checking whether Azure Group "' + $GroupName  +'" exists.'
    write-Host $prompt
    if (  ( util\check-group $GroupName   ) -eq $true)
    {
        $prompt = 'Azure Resource Group "' + $GroupName +'" already exists. Press [Enter] to return.'
        read-Host $prompt
        return 'Exists'
    }
    
    $global:GroupName = $null
    $global:HubName = $null
    $global:HubsStrn = $null
    $global:DevicesStrn=$null
    $global:DeviceName=$null
    $prompt = 'Creating new Azure Resource Group "' + $GroupName + '" at location "' + $Location +'"'
    write-Host $prompt
    az group create --name $GroupName --location $Location | Out-String

    $prompt = 'Checking whether Azure Group "' + $GroupName   +'" was created.'
    write-Host $prompt
    # Need to refresh the list of groups
    if  (( util\check-group $GroupName $true  ) -eq $true)
       {
        $prompt = 'It was created. Press [Enter] to return'
        read-Host $prompt
        $global:GroupName =$GroupName
        $global:HubName = $null
        $global:HubsStrn = $null
        $global:DevicesStrn=$null
        $global:DeviceName=$null
        return $GroupName
    }
    else
    {
        #If not found after trying to create it, must be inerror
        $prompt = 'It Failed. Press [Enter] to exit.'
        read-Host $prompt
        $global:GroupName = $null
        $global:GroupsStrn = $null
        $global:HubName = $null
        $global:HubsStrn = $null
        $global:DevicesStrn=$null
        $global:DeviceName=$null
        return 'Error'
    }
  
 
}
else 
{
    $prompt = 'Checking whether Azure Group "' + $GroupName  + '" in Subscription "' + $Subscription +'" exists.' + '# at location "' + $Location +'"'
    write-Host $prompt
    if (  ( az group exists --name $GroupName  --subscription $Subscription) -eq $true)
    {

        $prompt = 'Azure Resource Group "' + $GroupName +'" already exists. Returning. Press[Enter] to return.'
        read-Host $prompt
        return 'Exists'
    }
    $global:GroupName = $null
    $global:HubName = $null
    $global:HubsStrn = $null
    $global:DevicesStrn=$null
    $global:DeviceName=$null
    $prompt = 'Creeating new Azure Resource Group "' + $GroupName +'"'
    write-Host $prompt
    az group create --name $GroupName --location $Location --subscription $Subscription | Out-String
 
    $prompt = 'Checking whether Azure Group "' + $GroupName  + '" in Subscription "' + $Subscription +'" was craeted.'
    write-Host $prompt
    if (  ( az group exists --name $GroupName  --subscription $Subscription) -eq $true)
    {
        $prompt = 'Group was created. Press [Enter] to return.'
        read-Host $prompt
        $global:GroupName = $GroupName
        $global:HubName = $null
        $global:HubsStrn = $null
        $global:DevicesStrn=$null
        $global:DeviceName=$null
        return $GroupName
    }
    else 
    {
        #If not found after trying to create it, must be inerror
        $prompt = 'Group not created. Press [Enter] to exit.'
        read-Host $prompt
        $global:GroupName = $null
        $global:GroupsStrn = $null
        $global:HubName = $null
        $global:HubsStrn = $null
        $global:DevicesStrn=$null
        $global:DeviceName=$null
        return 'Error'    }
}

