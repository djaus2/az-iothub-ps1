function Get-Group{
param (
    [string]$Subscription = '' ,
    [string]$Current='',
    [boolean]$Refresh=$false
)

show-heading '  G R O U P  '  2
$Prompt =  ' Subscription :"' + $Subscription +'"'
write-Host $Prompt
$Prompt = ' Current Group :"' + $GroupName +'"'


    If ([string]::IsNullOrEmpty($Subscription ))
    {
        write-Host ''
        $prompt =  'Need to select a Subscription first.'
        write-host $prompt
        get-anykey 
        $global:DeviceName =  'Back'
        return
    }

    # $GroupStrnIndex =3
    # $GroupStrnDataIndex =3



   $GroupName = $Current
    do{

    if ($Refresh -eq $true)
    {
        $global:GroupsStrn = null
    }
    
    
  
        if ($null -eq $GroupName)
        {
            $GroupName =''
        }
        $Current=$GroupName


    If ([string]::IsNullOrEmpty($global:GroupsStrn )) 
    {   
        write-Host 'Getting Groups from Azure'
        if(-not([string]::IsNullOrEmpty($global:echoCommands)))
        {
            write-Host "Get Groups Command:"
            write-host "$global:GroupsStrn =  az group list --subscription  $Subscription -o tsv | Out-String"
            get-anykey
        }
        $global:GroupsStrn =  az group list --subscription  $Subscription -o tsv | Out-String
    }
    If ([string]::IsNullOrEmpty($global:GroupsStrn ))
    {
        $Prompt = 'No Groups found in Subscription "' + $Subscription + '".'
        write-Host $Prompt
        $global:GroupsStrn ='Empty'
    }

	show-heading '  G R O U P  '  2
	$Prompt =  ' Subscription :"' + $Subscription +'"'
	write-Host $Prompt
	$Prompt = ' Current Group :"' + $GroupName +'"'
    

       $options = 'N. New,R. Refresh'
        If (-not [string]::IsNullOrEmpty($Current )){
            $options = "$options,U. Unselect,D. Delete"
        }

        $options="$options,B. Back"
    parse-list $global:GroupsStrn  '  G R O U P  ' $options  $GroupStrnIndex  $GroupStrnDataIndex  3 36  $Current
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
    elseif ($answer -eq 'Error')
    {
        write-Host 'Error'

    }
    elseif ($answer -eq 'Unselect')
	{
	    $Current=$null
        write-Host 'CLEAR_CURRENT_GROUP'
        $global:GroupName = $null
	    $GroupName=$null   
	    $global:HubsStrn = $null
	    $global:HubName = $null	
        $global:DevicesStrn=$null
        $global:DeviceName=$null
	}
    elseif ($answer -eq 'New')
    {
        write-Host 'New'
        new-Group $Subscription
        $answer = $global:retVal
        if ($answer -eq 'Done')
        {
            $answer  = $global:GroupName
            $GroupName=$answer
	        $global:HubsStrn=$null
            $global:HubeName=$null
            $global:DevicesStrn=$null
            $global:DeviceName=$null
        }
        elseif($answer -eq 'Exists')
        {
        }
        elseif($answer -eq 'Back')
        {
        }
        elseif($answer -eq 'Error')
        {
        }

    }
    elseif ($answer -eq 'Delete')
    {
        write-Host 'Delete'
       Remove-Group  $Subscription $GroupName
        $answer = $global:retVal
        if ($answer -eq 'Done')
        {
            $GroupName=$null
	    $global:GroupName=$null
        }
        elseif($answer -eq 'Exists')
        {
        }
        elseif($answer -eq 'Back')
        {
        }
        elseif($answer -eq 'Error')
        {
        }
    }
    elseif ($answer -eq 'Refresh')
    {
        write-Host 'Refresh'
        $Refresh = $true
    }
    elseif ($answer -eq $global:GroupName)
    {
        $answer ='Back'
    }
    elseif ($answer -ne $global:GroupName)
    {
        $global:GroupName =  $answer
        $Current = $answer
	    $GroupName = $answer
	    $global:HubsStrn=$null
	    $global:HubName = $null      
        $global:DevicesStrn=$null
        $global:DevicNamee=$null
        $global:DPSStrn= $null
        $global:DPSName=$null
        
        if ($global:doneItem)
        {
            $answer='Back'             
        }
       $global:doneItem = $null
    }
 } while (($answer -ne 'Back') -and ($answer -ne 'Error'))
    $global:retVal =  $answer 
}