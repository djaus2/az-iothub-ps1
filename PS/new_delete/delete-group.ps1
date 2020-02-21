function Remove-Group{
param (
    [Parameter(Mandatory)]
    [string]$Subscription,
    [string]$GroupName,
    [boolean]$Refresh=$false
)
. ("$global:ScriptDirectory\Util\Check-Group.ps1")

    $GroupStrnIndex =3
    $GroupStrnDataIndex =3
    If ([string]::IsNullOrEmpty($Subscription ))
    {
        write-Host ''
        $prompt= 'Need to select a Subscription first.'
        get-anykey $prompt
        $global:retVal = 'Back'
        return
    }

  
    # Force refresh of list of Groups
    $Refresh = $true
    if ($Refresh -eq $true)
    {
        $global:GroupsStrn  = $null
    }

    util\heading '  D E L E T E  G R O U P  '  DarkRed  White

    # Need a Group name
    if ([string]::IsNullOrEmpty($GroupName))
    {
        If ([string]::IsNullOrEmpty($global:GroupsStrn ))
        {   
            write-Host 'Getting Groups from Azure'
            $global:GroupsStrn =  az group list -o tsv | Out-String
            if(-not([string]::IsNullOrEmpty($global:echoCommands)))
            {
                write-Host "Get Groups Command:"
                write-host "$global:GroupsStrn =  az group list --subscription  $global:Subscription -o tsv | Out-String"
            }
            $global:GroupsStrn =  az group list --subscription  $global:Subscription -o tsv | Out-String
        }
        If ([string]::IsNullOrEmpty($global:GroupsStrn ))
        {
            $Prompt = 'No Groups found in Subscription.'
            get-anykey $prompt
           $global:retVal = 'Back'           
	        return
        }
        
        parse-list $global:GroupsStrn  '  G R O U P  ' 'B. Back'   $GroupStrnIndex $GroupStrnIndex  3 36  ''
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
        $GroupName = $answer
    }

    $prompt =  'Do you want to delete the group "' + $GroupName +  '"'
    write-Host $prompt
    get-yesorno $false
    $answer = $global:retVal
    if  (-not $answer )
    {
	    $global:retVal = 'Back'
        return
    }

    $global:GroupName= $null
    $global:GroupsStrn= $null
    $global:HubName= $null
    $global:HubsStrn=$null
    $global:DeviceName = $null
    $global:DevicesStrn=$null

    if  ( check-group $Subscription $GroupName  ) 
    {
        $prompt = 'Deleting Azure Resource Group "' + $GroupName + '"'
        write-Host $prompt
        if(-not([string]::IsNullOrEmpty($global:echoCommands)))
        {
            write-Host "Delete Group Command:"
            write-Host "az group delete --name  $GroupName"
        }
        az group delete --name $GroupName  


    	$prompt = 'Checking whether Azure Group "' + $GroupName   +'" was deleted.'
    	write-Host $prompt

    	$global:GroupsStrn=$null
    	if ( check-group $Subscription $GroupName) 
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
        $prompt = 'Azure Resource Group "' + $GroupName +'" doesnt exist.'
        get-anykey $prompt
        $global:retVal = 'Back'

    }
}
