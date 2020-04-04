function Get-DPS{
param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$DPSName = '' ,
    [string]$Current = '',
    [boolean]$Refresh=$false
)

If ([string]::IsNullOrEmpty($Subscription ))
{
    write-Host ''
    $prompt =  'Need to select a Subscription first.'
    get-anykey $prompt
    $global:DPS =  'Back'
    return
}
elseIf ([string]::IsNullOrEmpty($GroupName ))
{
    write-Host ''
    $prompt = 'Need to select a Group first.'
    get-anykey $prompt
    $global:DPS =  'Back'
    return
}
elseIf ([string]::IsNullOrEmpty($HubName ))
{
    write-Host ''
    prompt =  'Need to select a Hub first.'
    get-anykey $prompt
    $global:DPS =  'Back'
    return
}

    $DPSStrnIndex =3
    $DPSStrnDataIndex =5




    show-heading '  D E V I C E  P R O V I S I O N I N G  S E R V I C E (DPS)  '  2
    $Prompt = '   Subscription :"' + $Subscription +'"'
    write-Host $Prompt
    $Prompt = '          Group :"' + $GroupName +'"'
    write-Host $Prompt
    $Prompt = '            Hub :"' + $HubName +'"'
    write-Host $prompt
    $Prompt = '         Device :"' + $DeviceName +'"'
    write-Host $Prompt
    $Prompt = '    Current DPS :"' + $Current +'"'
    write-Host $Prompt


    if ($Refresh -eq $true)
    {
        $global:DPSStrn = null
    }
    elseif(-not([string]::IsNullOrEmpty($current)))
    {
        get-yesorno $True "Do you want to use the Current DPS? (Y/N)"
        $answer = $global:retVal
        if  ( $answer)
        {
            $global:retVal ='Back'
            return $current
        }
    }

    [boolean]$skip = $false
    if  ($global:DPSStrn -eq '')
    {
        # This allows for previously returned empty string
        $skip = $true
    }
    If  (([string]::IsNullOrEmpty($global:DPSStrn ))  -and (-not $skip))
    {   
        write-Host 'Getting DPS from Azure'
        if(-not([string]::IsNullOrEmpty($global:echoCommands)))
        {
            write-Host "Get DPS Command:"
            write-host "$global:DPSStrn =  az iot dps list --resource-group $GroupName  -o tsv | Out-String "
        }
        $global:DPSStrn =  az iot dps list --resource-group $GroupName   -o tsv | Out-String
    }
    If ([string]::IsNullOrEmpty($global:DPSStrn ))
    {
        $Prompt = 'No DPS found in Group "' + $GroupName + '".'
        write-Host $Prompt
        $Prompt ='Do you want to create a new DPS for the Group "'+ $GroupName +'"?'
        write-Host $prompt
        get-yesorno $true
	$answer =  $global:retVal
        if ($answer )
        {
            write-Host 'New DPS for the Group'
            $global:retVal = 'New'
        }
        else {
            write-Host 'Returning'
            $global:retVal = 'Back'
        }
        return
    }

    parse-list $global:DPSStrn   '  D P S  '  'N. New,D. Delete,B. Back'  $DPSStrnIndex $DPSStrnIndex 2  22 $Current
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
    elseif ($answer -ne $global:DPSName)
    {
        $global:DPSName = $answer 
        $global:retVal =  $answer
    }
    elseif ($answer -eq 'Error')
    {
        write-Host 'Error'

    }
    $global:retval = $answer 
}