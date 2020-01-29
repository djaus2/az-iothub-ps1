function Remove-Group{
param (
    [string]$Subscription='',
    [string]$GroupName=''
)

    If ([string]::IsNullOrEmpty($Subscription ))
    {
        write-Host ''
        $prompt= 'Need to select a Subscription first.'
        menu\any-key $prompt
        return 'Back'
    }

    $GroupStrnIndex =3
    # Force refresh of list og Groups
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
            # $global:GroupsStrn =  az group list --subscription  $global:Subscription -o tsv | Out-String
        }
        If ([string]::IsNullOrEmpty($global:GroupsStrn ))
        {
            $Prompt = 'No Groups found in Subscription.'
            menu\any-key $prompt
            return 'Back'
        }
        
        $answer = menu\parse-list $global:GroupsStrn  '  G R O U P  ' 'B. Back'   $GroupStrnIndex $GroupStrnIndex  3 36  ''
        
        If ([string]::IsNullOrEmpty($answer ))
        {
            return 'Back'
        }
        elseif ($answer -eq 'Back')
        {
            return 'Back'
        }
        elseif ($answer -eq 'Error')
        {
        return 'Error'
        }
        $GroupName = $answer
    }

    $prompt =  'Do you want to delete the group "' + $GroupName +  '"'
    $answer = menu\yes-no $prompt 'N'
    if  (-not $answer )
    {
        return 'Back'
    }

    $global:GroupName= $null
    $global:GroupsStrn= $null
    $global:HubName= $null
    $global:HubsStrn=$null
    $global:DeviceName = $null
    $global:DevicesStrn=$null

    if  ( util\check-group $GroupName  ) 
    {
        $prompt = 'Deleting Azure Resource Group "' + $GroupName + '"'
        write-Host $prompt
        if(-not([string]::IsNullOrEmpty($global:echoCommands)))
        {
            write-Host "az group delete --name  $GroupName"
        }
        az group delete --name $GroupName  
    }
    else 
    {
        $prompt = 'Azure Resource Group "' + $GroupName +'" doesnt exist.'
        menu\any-key $prompt
        return 'Back'
    }

    $prompt = 'Checking whether Azure Group "' + $GroupName   +'" was deleted.'
    write-Host $prompt

    $global:GroupsStrn=$null
    if ( util\check-group $GroupName) 
    {
        $prompt = 'It Failed.'
        menu\any-key $prompt
        return  'Error'
    }
    else 
    {
        $prompt = 'It was deleted.'
        menu\any-key $prompt
        return 'Back'
    }
}
