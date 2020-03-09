function New-Group{
param (
    [Parameter(Mandatory)]
    [string]$Subscription = '' ,
    [string]$GroupName='',
    [string]$Location=''
)

    
    try {
        . ("$global:ScriptDirectory\Util\Check-Group.ps1")
        . ("$global:ScriptDirectory\Util\get-location.ps1")
    }
    catch {
        Write-Host "Error while loading supporting PowerShell Scripts" 
        Write-Host $_
    }
    
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


    show-heading '  N E W  G R O U P  '   3



    # Need a group name
    if ([string]::IsNullOrEmpty($GroupName))
    {
        $answer = get-name 'Resource Group'
        if ($answer -eq 'Back')
        {
            write-Host 'Returning'
            return 'Back'
        }
        $GroupName = $answer
    }

    $location = get-Location
    $result = $global:retVal

    $prompt = 'Location for Resource Group is "' + $result +'"'
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
    $prompt = 'Creating new Azure Resource Group "' + $GroupName +'"'
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
