function get-azsphere{
param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$DPSName = '',
    [string]$Tenant='',
    [String]$TenantName='',
    [boolean]$Refresh=$false
)


    show-heading '  A Z U R E  S P E R E  '  2
    $Prompt = '   Subscription :"' + $Subscription +'"'
    write-Host $Prompt
    $Prompt = '          Group :"' + $GroupName +'"'
    write-Host $Prompt
    $Prompt = '            Hub :"' + $HubName +'"'
    write-Host $Prompt
    $Prompt = '    Current DPS :"' + $DPSName +'"'
    write-Host $Prompt
    $Prompt = ' Current Tenant :"' + $TenantName +'"'
    write-Host $Prompt

 

    If ([string]::IsNullOrEmpty($Subscription ))
    {
        write-Host ''
        $prompt =  'Need to select a Subscription first.'
        write-host $prompt
        get-anykey 
        $global:DPS =  'Back'
        return
    }
    elseIf ([string]::IsNullOrEmpty($GroupName ))
    {
        write-Host ''
        $prompt = 'Need to select a Group first.'
        write-host $prompt
        get-anykey 
        $global:DPS =  'Back'
        return
    }
    elseIf ([string]::IsNullOrEmpty($HubName ))
    {
        write-Host ''
        $prompt = 'Need to select a Hub first.'
        write-host $prompt
        get-anykey 
        $global:DPS =  'Back'
        return
    }
    elseIf ([string]::IsNullOrEmpty($DPsName ))
    {
        write-Host ''
        $prompt = 'Need to select a DPS first.'
        write-host $prompt
        get-anykey 
        $global:DPS =  'Back'
        return
    }


  


    $DPSStrnIndex =3
    $DPSStrnDataIndex =5


    do{

        if ($Refresh -eq $true)
        {
        $   Refresh=$false
        }


        show-heading '  A Z U R E  S P H E R E  '  2
        $Prompt = '   Subscription :"' + $Subscription +'"'
        write-Host $Prompt
        $Prompt = '          Group :"' + $GroupName +'"'
        write-Host $Prompt
        $Prompt = '            Hub :"' + $HubName +'"'
        write-Host $Prompt
        $Prompt = '    Current DPS :"' + $DPSName +'"'
        write-Host $Prompt
        $Prompt = ' Current Tenent :"' + $TenantName +'"'
        write-Host $Prompt

        $options ='P. AzspherePrompt,L. Login,T. Get Tenant,C. Create Certificate,E. New Enrollment Group'

        $options="$options,B. Back"

        parse-shortlist 'EMPTY'   '   A Z U R E  S P H E R E  '  $options $DPSStrnIndex $DPSStrnIndex 2  22 $Current
        $answer= $global:retVal
	    write-host $answer

        If ([string]::IsNullOrEmpty($answer)) 
        {
            write-Host 'Back'
            $answer = 'Back'
        }
        elseif ($answer-eq 'Back')
        {
            write-Host 'Back'
        }
        elseif ($answer-eq 'Error')
        {
            write-Host 'Error'
        }
        else {
            $kk = $global:kk
            $global:kk = $null
            switch ($kk)
            {
                'P' {enter-azsphere}
                'L' {
                       azsphere login
                    }
                'T' {
                    $Tenant=$null
                    $TenantName=$null
                    $getTenant = azsphere tenant show-selected
                    If ([string]::IsNullOrEmpty($getTenant))
                    {
                         read-host "No Tenants or None Selected"
                    }
                    else
                    {
                        $getTenantLines = $getTenant -split ' '
                        [int] $numLines = $getTenantLines.Count
                        if ($numLines -ne 8)
                        {
                            write-host $getTenant
                            read-host 'Invalid return from Show Selected Tenant query'
                        }
                        else
                        {
                            $ten = $getTenantLines[$numLines-1]
                            $tenName = $getTenantLines[$numLines-2]
                            $Tenant = $ten.Substring(1,$ten.Length-3)
                            $TenantName= $tenName.Substring(1,$tenName.Length-2)
                        }
                    }
                    $global:Tenant= $Tenant
                    $global:TenantName = $TenantName
                    }
                'C' {
                    create-azsphere $global:subscription $global:groupname $global:hubname $global:dpsname 
                    }
                'E' {}


            }
        }
        

    } while (($answer -ne 'Back') -and ($answer -ne 'Error'))

    $global:retval = $answer
}
