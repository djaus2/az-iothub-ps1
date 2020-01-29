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
        return 'Back'
    }
    elseIf ([string]::IsNullOrEmpty($GroupName ))
    {
        write-Host ''
        $prompt = 'Need to select a Group first'
        get-anykey $prompt
        return 'Back'
    }

    $HubStrnIndex =3
    $HubStrnDataIndex =3




    util\heading '  I o T  H U B  '  -BG DarkBlue   -FG White
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
        $global:HubsStrn =  az iot hub list --resource-group  $GroupName  -o tsv | Out-String
    }
    If ([string]::IsNullOrEmpty($global:HubsStrn ))
    {
        $Prompt = 'No Hubs found in Group "' + $GroupName + '".'
        write-Host $Prompt
        $Prompt ='Do you want to create a new Hub for the Group "'+ $GroupName +'"?'
        write-Host $prompt
        $answer = get-yesorno $false
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

    parse-list $global:HubsStrn   '  H U B  '  'N. New,D. Delete,B. Back'  $HubStrnIndex $HubStrnDataIndex 2  22 $Current
    $answer= $global:retVal
    write-Host $answer

    If ([string]::IsNullOrEmpty($answer)) 
    {
        write-Host 'Back'
        $global:retVal =  'Back'
    }
    elseif ($answer-eq 'Back')
    {
        write-Host 'Back'
        $global:retVal =  'Back'
    }
    elseif ($answer -eq 'New')
    {
        write-Host 'New'
        $global:retVal =  'New'
    }
    elseif ($answer -eq 'Delete')
    {
        write-Host 'Delete'
        $global:retVal =  'Delete'
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
        $global:retVal =  'Error'

    }
}