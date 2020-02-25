function Get-Group{
param (
    [string]$Subscription = '' ,
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

    # $GroupStrnIndex =3
    # $GroupStrnDataIndex =3


    show-heading '  G R O U P  '  Magenta   White
    $Prompt = ' Subscription :"' + $Subscription +'"'
    write-Host $Prompt
    $Prompt = 'Current Group :"' + $Current +'"'
    write-Host $Prompt


    if ($Refresh -eq $true)
    {
        $global:GroupsStrn = null
    }
    [boolean]$skip = $false
    if ($global:GroupsStrn -eq '')
    {
        # This allows for previously returned empty string
        $skip = $true
    }
    If (([string]::IsNullOrEmpty($global:GroupsStrn ))  -and (-not $skip))
    {   
        write-Host 'Getting Groups from Azure'
        if(-not([string]::IsNullOrEmpty($global:echoCommands)))
        {
            write-Host "Get Groups Command:"
            write-host "$global:GroupsStrn =  az group list --subscription  $global:Subscription -o tsv | Out-String"
        }
        $global:GroupsStrn =  az group list --subscription  $global:Subscription -o tsv | Out-String
    }
    If ([string]::IsNullOrEmpty($global:GroupsStrn ))
    {
        $Prompt = 'No Groups found in Subscription "' + $Subscription + '".'
        write-Host $Prompt
        $Prompt ='Do you want to create a new Group for the Subscription "'+ $Subscription +'"?'
        write-Host $prompt
        get-yesorno $false
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

    parse-list $global:GroupsStrn  '  G R O U P  ' 'N. New,D. Delete'   $GroupStrnIndex  $GroupStrnDataIndex  3 36  $Current
    $answer = $global:retVal
    write-Host $answer

    If ([string]::IsNullOrEmpty($answer)) 
    {
        write-Host 'Back'
        $answer=  'Back'
    }
    elseif ($answer -eq 'Back')
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
    elseif ($answer -ne $global:GroupName)
    {
        $global:GroupName =  $answer

        $global:HubsStrn=$null
        $global:DevicesStrn=$null
        $global:Hub = $null
        $global:Device=$null
    }
    elseif ($answer -eq 'Error')
    {
        write-Host 'Error'
    }
    $global:retVal =  $answer 
}