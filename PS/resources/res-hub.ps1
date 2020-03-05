function Get-Hub{
param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
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
        $prompt = 'Need to select a Group first'
        get-anykey $prompt
        $global:DeviceName =  'Back'
        return
    }

    # $HubStrnIndex =3
    # $HubStrnDataIndex =3




    show-heading '  I o T  H U B  '  2
    $Prompt =  'Subscription :"' + $Subscription +'"'
    write-Host $Prompt
    $Prompt = '       Group :"' + $GroupName +'"'
    write-Host $Prompt
    $Prompt = ' Current Hub :"' + $Current +'"'
    write-Host $Prompt


    if ($Refresh -eq $true)
    {
        $global:HubsStrn = null
    }
    [boolean]$skip = $false
    if  ($global:HubsStrn -eq '')
    {
        # This allows for previously returned empty string
        $skip = $true
    }
    If  (([string]::IsNullOrEmpty($global:HubsStrn ))  -and (-not $skip))
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
        $Prompt ='Do you want to create a new Hub for the Group "'+ $GroupName +'"?'
        write-Host $prompt
        get-yesorno $true
	$answer =  $global:retVal
        if ($answer )
        {
            write-Host 'New Group'
            $global:retVal = 'New'
        }
        else {
            write-Host 'Returning'
            $global:retVal = 'Back'
        }
        return
    }

    parse-list $global:HubsStrn   '  H U B  '  'N. New,D. Delete'  $HubStrnIndex $HubStrnDataIndex 2  22 $Current
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
    elseif ($answer -eq 'New')
    {
        write-Host 'New'
    }
    elseif ($answer -eq 'Delete')
    {
        write-Host 'Delete'
    }
    elseif ($answer -ne $global:HubName)
    {
        $global:HubName = $answer 
        $global:DevicesStrn=$null
        $global:Device=$null
        $global:retVal =  $answer
    }
    elseif ($answer -eq 'Error')
    {
        write-Host 'Error'

    }
    $global:retval = $answer 
}