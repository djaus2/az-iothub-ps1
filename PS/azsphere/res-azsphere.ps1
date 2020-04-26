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


  
    $DPSidscope=$global:DPSidscope

    $DPSStrnIndex =3
    $DPSStrnDataIndex =5


    do{

        if ($Refresh -eq $true)
        {
            $Refresh=$false
        }


        show-heading '  A Z U R E  S P H E R E  '  2
        $Prompt = '     Subscription :"' + $Subscription +'"'
        write-Host $Prompt
        $Prompt = '            Group :"' + $GroupName +'"'
        write-Host $Prompt
        $Prompt = '              Hub :"' + $HubName +'"'
        write-Host $Prompt
        $Prompt = '              DPS :"' + $DPSName +'"'
        write-Host $Prompt
        write-host ' ------------------------------------ '
        $Prompt = '      Tenant Name :"' + $TenantName +'"'
        write-Host $Prompt
        $Prompt = '           Tenant :"' + $Tenant +'"'
        write-Host $Prompt
        $Prompt = '     DPS ID Scope :"' + $DPSIdScope +'"'
        write-Host $Prompt
        $Prompt = ' IOT Hub DNS Name :"' + $HubName + '.azure-devices-provisioning.net"'
        write-Host $Prompt

        #$options ='A. Enter Azure Sphere Developer Command Prompt (PS Version),L. Login to Azure Sphere,T. Get Tenant,S. Select Tenant,S. Existing app sideload delete,R. Restart Device,D. Enable Debugging,W. Wifi,O. Check OS Version,T. Trigger Update, U. Check Update Status'
        $options ='A. Enter Azure Sphere Developer Command Prompt (PS Version),L. Login to Azure Sphere,T. Tenat,W. WiFi,U. Update,D. App Dev settings'
        
        # -S. Existing app sideload delete,R. Restart Device,D. Enable Debugging,W. Wifi,O. Check OS Version,T. Trigger Update, U. Check Update Status'

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
            
            $kk = [char]::ToUpper($global:kk)
            $global:kk = $null
            switch ($kk)
            {
                'A' { enter-azsphere}
                'L' { azsphere login}
                'T' {
                    $options='T. Get Tenant,L. List Tenants,S. Set Tenant,B.Back'
                    parse-shortlist 'EMPTY'   '   A Z U R E  S P H E R E  '  $options 0 0  2  22 ''
                        switch($kk){
                            'B' {Continue}
                            'T'{
                                $Tenant=$null
                                $TenantName=$null
                                $getTenant = azsphere tenant show-selected
                                If ([string]::IsNullOrEmpty($getTenant))
                                {
                                    write-host "No Tenants or None Selected"
                                    get-anykey '' "Coninue"
                                }
                                else
                                {
                                    $getTenantLines = $getTenant -split ' '
                                    [int] $numLines = $getTenantLines.Count
                                    if ($numLines -ne 8)
                                    {
                                        write-host $getTenant
                                        write-host 'Invalid return from Show Selected Tenant query'
                                        get-anykey '' "Coninue"
                                    }
                                    else
                                    {
                                        $ten = $getTenantLines[$numLines-1]
                                        $tenName = $getTenantLines[$numLines-2]
                                        $Tenant = $ten.Substring(1,$ten.Length-3)
                                        $TenantName= $tenName.Substring(1,$tenName.Length-2)
                                        write-host "TenantName: $TenantName Tenant: $Tenant"
                                        get-anykey '' "Coninue"
                                    }
                                }
                                $global:Tenant= $Tenant
                                $global:TenantName = $TenantName
                            }
                            'L'{
                                azsphere tenant list 
                                get-anykey '' 'Continue'
                            }
                            's'{
                                # Should improve this
                                show-heading '  A Z U R E  S P H E R E : Select Tenant '  3
                                write-host ''
                                $tl= azsphere tenant list
                                if ($tl.Length  -lt 3)
                                {
                                    write-host 'No Tenants available'
                                    read-host ' '
                                }
                                else
                                {
                                    [int]$numTenants=$tl.Length-2
                                    write-host "There are $numTenants Tenants"
                                    $start = 2
                                    $stop = 2 + $numTenants 
                                    write-host ''
                                    write-host "Select the Tenant"
                                    for ($i=$start;$i -lt $stop;$i++)
                                    {
                                        $var = $tl[$i]
                                        $z = $var -split ' '
                                        write-host ($i-1) $z[1]  $z[0]
                                    }
                                    $numStrn = read-host 'Enter its number. Default = 1'
                                    $num=1
                                    If (-not([string]::IsNullOrEmpty($answer)) )
                                    {
                                        if($numStrn -match '^\d+$')
                                        {
                                            [int]$num = [int]($numStrn.Trim())
                                            if(($num -gt $numTenants) -or ( $num -lt 1))
                                            {
                                                $num=1
                                            }
                                        }
                                    }                          
                                    $var = $tl[$num+1]
                                    $z = $var -split ' '
                                    $TenantName = $z[1]
                                    $Tenant=$z[0]
                                    azsphere tenant select --tenantid $Tenant
                                    $global:Tenant= $Tenant
                                    $global:TenantName = $TenantName

                                }
                            }

                        }
                }
                'D' {
                    $options='E. Enable Development,D. Existing app sideload Delete,R. Restart Device,,B.Back'
                    parse-shortlist 'EMPTY'   '   A Z U R E  S P H E R E  '  $options 0 0  2  22 ''
                        switch($kk){
                            'E'{
                                write-host 'Enabling Development (Wait):'
                                azsphere device enable-development
                                get-anykey '' 'Continue'
                            }
                            'D'{
                                write-host 'Deleting existing sideloaded app (Wait):'
                                azsphere device sideload delete
                                get-anykey '' 'Continue'
                            }
                        }

                }
                'W' {
                    $options='W. Get WifI Status,A. Add WiFi Network,L. List Access Points,B.Back'
                    parse-shortlist 'EMPTY'   '   A Z U R E  S P H E R E  '  $options 0 0  2  22 ''
                    switch ($kk){
                        'W' {
                            write-host 'Getting Wifi Status (Wait)'
                            azsphere device wifi show-status
                            get-anykey '' 'Continue'
                        }
                        'A' {
                            write-host 'Getting Wifi Access Points (Wait)'
                            azsphere device wifiscan
                            get-anykey '' 'Continue'
                            write-host 'Getting Wifi Status (Wait)'
                            write-host "azsphere device wifi add --ssid '<yourSSID>' --psk '<yourNetworkKey>'"
                            get-anykey '' 'Continue'
                        }
                        'L' {
                            write-host 'Getting Wifi Access Points (Wait)'
                            azsphere device wifiscan
                            get-anykey '' 'Continue'
                        }
                    }
                }
                'U' {
                    $options='O. Show OS Version,E. Get Update Status,R. Restart Device,,B.Back'
                    parse-shortlist 'EMPTY'   '   A Z U R E  S P H E R E  '  $options 0 0  2  22 ''
                    switch ($kk){
                        'U' {
                            write-host 'Getting Update Status (Wait):'
                            azsphere device show-deployment-status
                            get-anykey '' 'Continue'
                        }
                        'O' {
                            write-host 'Getting OS Version (Wait):'
                            azsphere device sshow os-version
                            get-anykey '' 'Continue'
                        }
                        'R'{
                            write-host 'Restarting device (Wait):'
                            azsphere device enable-development
                            get-anykey '' 'Continue'
                        }
                    }
                }

            }
        }
    } while (($answer -ne 'Back') -and ($answer -ne 'Error'))

    $global:retval = $answer
}
