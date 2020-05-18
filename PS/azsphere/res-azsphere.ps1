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

    If ([string]::IsNullOrEmpty($global:AzSphereLoggedIn ))
    {
        write-host ''
        enter-azsphere
        $global:AzSphereLoggedIn ="LoggedIn"
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
        $Prompt = ' IoT Hub DNS Name :"' + $HubName + '.azure-devices-provisioning.net"'
        write-Host $Prompt
        write-host ''
        write-host "Azure Sphere SDK setup available in Main Menu --> Setup, option Z"   -ForegroundColor   Yellow
        write-host ''



        #$options ='A. Enter Azure Sphere Developer Command Prompt (PS Version),L. Login to Azure Sphere,T. Get Tenant,S. Select Tenant,S. Existing app sideload delete,R. Restart Device,D. Enable Debugging,W. Wifi,O. Check OS Version,T. Trigger Update, U. Check Update Status'
        $options ='A. Do all AzSphere Hub-DPS Connection,E. Enter Azure Sphere Developer Command Prompt (PS Version) and Login,L. Login to Azure Sphere,T. Tenant,W. WiFi,U. Update,D. App Dev settings,C. Connect via IoT Hub and DPS'
        
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
                'A' {
                    doall-azsphere-iothub-dps $global:subscription $global:groupname $global:hubname $global:dpsname $Tenant $TenantName
                    $Tenant = $global:Tenant
                    $TenantName = $global:TenantName
                    $DPSIDScope = $global:DPSIDScope
                }
                'C' {
                        get-azsphereDPS $Subscription $GroupName $HubName $DPSName $Tenant $TenantName
                    }
                'E' {   
                        enter-azsphere
                        $global:AzSphereLoggedIn ="LoggedInAgain"
                    }
                'L' { 
                        azsphere login
                        $global:AzSphereLoggedIn ="LoggedInOnly"
                    }
                'T' {
                    do{
                        show-heading '  A Z U R E  S P H E R E : Tenant xx '  4
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
                        $Prompt = ' IoT Hub DNS Name :"' + $HubName + '.azure-devices-provisioning.net"'
                        write-host ''
                        $options='T. Get Tenant,L. List Tenants,S. Set Tenant,V. Validate Tenant'
                        If (-not([string]::IsNullOrEmpty($CanClaimDevice ))){
                            $options += ',L. Create new Tenant,C. Claim Device'
                        }
                        $options +=",B. Back"
                        parse-shortlist 'EMPTY'   '   A Z U R E  S P H E R E  '  $options 0 0  2  22 ''
                        
                        $kk2 = [char]::ToUpper($global:kk)
                        $global:kk = $null 
                        switch($kk2){
                            'B' {
                                If (-not([string]::IsNullOrEmpty($global:CanClaimDevice )))
                                {
                                    remove-variable CanClaimDevice  -Scope Global
                                }                          
                            }
                            'T'{
                                show-heading '  A Z U R E  S P H E R E : Get Tenant GT'  3
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
                                $Prompt = ' IoT Hub DNS Name :"' + $HubName + '.azure-devices-provisioning.net"'
                                $Tenant=$null
                                $TenantName=$null
                                $getTenant = azsphere tenant show-selected
                                If ([string]::IsNullOrEmpty($getTenant))
                                {
                                    write-host "No Tenants or None Selected"
                                    get-anykey '' "Continue"
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
                                write-host 'Getting Tenant List (Wait):'
                                azsphere tenant list 
                                get-anykey '' 'Continue'
                            }
                            's'{
                                # Should improve this
                                show-heading '  A Z U R E  S P H E R E : Select Tenant '  4
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
                                $Prompt = ' IoT Hub DNS Name :"' + $HubName + '.azure-devices-provisioning.net"'
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
                            'V'{
                                write-host 'Verify Tenant'
                                write-host '============='
                                write-Host "For an IoT Hub - DPS connection Validation see:"
                                write-host " 'H. Connect via IoT Hub'-->C. Create Certificate on DPS and Verify it."
                                write-host " ... The current IoT Hub needs to be connected to the current DPS. "
                                write-host " See Main Menu-->5. DPS Menu then Options G. then C."
                                write-host ''
                                write-host "For an IoT Central - Watch this space."
                                get-anykey '' 'Continue'

                            }
                            'L'{
                                If (-not([string]::IsNullOrEmpty($global:CanClaimDevice )))
                                {
                                    write-host 'Creating new Tenant'
                                    $mytenant = read-host "Please enter the name for the new Tenant"
                                    Set-Clipboard -Value "azsphere tenant create --name $mytenant"
                                    write-host "Now please exit and run the command: azsphere tenant create --name $mytenant"
                                    write-host "You can paste it at the azsphere prompt from the Clipbaord (Cntrl-V)"
                                    get-anykey '' 'Continue'
                                }
                            }
                            'C'{
                                If (-not([string]::IsNullOrEmpty($global:CanClaimDevice )))
                                    {
                                    write-host 'Claiming Device'
                                    get-yesorno  $false 'This is irreverable. Do you really want to do this?'
                                    $answer = $global:retVal
                                    if ($answer)
                                    {
                                        get-yesorno  $false 'One last time: This is NOT UNDOABLE in any way, but is required. Do you really want to do this?'
                                        $answer = $global:retVal
                                        if ($answer)
                                        {
                                            write-host 'Claiming Device:'
                                            Set-Clipboard -Value "azsphere device claim"
                                            write-host 'Now please exit and run command: azsphere device claim'
                                            write-host "You can paste it at the azsphere prompt from the Clipbaord (Cntrl-V)"
                                            get-anykey '' 'Continue'
                                        }
                                    } 
                                    remove-variable CanClaimDevice  -Scope Global
                                }
                            }

                        }
                    } while ($kk2 -ne 'B')
                }
                'D' {
                    do{
                        show-heading '  A Z U R E  S P H E R E '  3 ' Development '
                        write-host 'NOTE:'  -BackgroundColor Yellow  -ForegroundColor   Black -nonewline
                        write-host ' ' -nonewline
                        write-host 'This menu requires the Device to be connected.'    -ForegroundColor   DarkRed 
                        write-host ''
                        $options='E. Enable Development,A. App Show Status,P. App Stop,S. App Start,D. Existing app sideload Delete,R. Restart Device,V. Show Security Services,T. Show Attached,G. Show Deployment Status,Y. Get Capability Configuration,B. Back'
                        parse-shortlist 'EMPTY'   '   A Z U R E  S P H E R E  '  $options 0 0  2  22 ''
  
                        $kk2 = [char]::ToUpper($global:kk)
                        $global:kk = $null
                        switch($kk2){
                            'E'{
                                write-host 'Enabling Development (Wait):'
                                azsphere device enable-development
                                get-anykey '' 'Continue'
                            }
                            'A'{
                                write-host 'App ... Getting Status (Wait):'
                                azsphere device app start
                                get-anykey '' 'Continue'
                            }
                            'P'{
                                write-host 'Stopping current app (Wait):'
                                azsphere device app stop
                                get-anykey '' 'Continue'
                            }
                            'S'{
                                write-host 'Stopping current app (Wait):'
                                azsphere device app start
                                get-anykey '' 'Continue'
                            }
                            'D'{
                                write-host 'Deleting existing sideloaded app (Wait):'
                                azsphere device sideload delete
                                get-anykey '' 'Continue'
                            }
                            'V'{
                                write-host 'Getting AzS Security Service stores (Wait):'
                                azsphere device show
                                get-anykey '' 'Continue'
                            }
                            'T'{
                                write-host 'Getting attached details (Wait):'
                                azsphere device show-attached
                                get-anykey '' 'Continue'
                            }
                            'G'{
                                write-host 'Getting attached details (Wait):'
                                azsphere device show-deployment-status
                                get-anykey '' 'Continue'
                            }
                            'Y' {
                                write-host 'Getting Capability Configuration (Wait):'
                                azsphere device capability show-attached
                                get-anykey '' 'Continue'
                            }
                        }
                    }
                    while ($kk2 -ne 'B')
                }
                'W' {
                    [int]$id=-1
                    do 
                    {
                        show-heading '  A Z U R E  S P H E R E  '  3  'WiFi'
                        write-host 'NOTE:'  -BackgroundColor Yellow  -ForegroundColor   Black -nonewline
                        write-host ' ' -nonewline
                        write-host 'This menu requires the Device to be connected.'    -ForegroundColor   DarkRed 
                        write-host ''
                        $options='W. Get WifI Status,S. Scan WiFi Networks,A. Add a WiFi Network,L. List and Select an added Wifi Network,F. Forget an added Wifi Network,E. Enable selected WiFi Network,D. Disable selected WiFi Network,B. Back'
                        parse-shortlist 'EMPTY'   '   A Z U R E  S P H E R E  '  $options 0 0  2  22 ''
                        $kk2 = [char]::ToUpper($global:kk)
                        $global:kk = $null
                        switch ($kk2){
                            'L' {
                                write-host 'Getting added Wifi List (Wait)'
                                azsphere device wifi list
                                $IdStrn = read-host 'Enter ID to select'
                                if($IdStrn -match "^\d+$"){
                                    [int]$Id = [int] $IdStrn
                                    write-host "ID: $id"
                                }
                                else{
                                    $Id = -1
                                    write-host 'Invalid'
                                    write-host "ID: $id"
                                }
                                get-anykey '' 'Continue'
                            }
                            'W' {
                                write-host 'Getting Wifi Status (Wait)'
                                azsphere device wifi show-status
                                get-anykey '' 'Continue'
                            }
                            'E' {
                                if ($id -lt 0)
                                {
                                    write-host "Please Select an Access Point ID first."
                                    get-anykey '' "Continue"
                                    Continue
                                }
                                write-host 'Enabling Wifi (Wait)'
                                azsphere device wifi enable  -id $id
                                $id = -1
                                get-anykey '' 'Continue'
                            }
                            'D' {
                                if ($id -lt 0)
                                {
                                    write-host "Please Select an Access Point ID first."
                                    get-anykey '' "Continue"
                                    Continue
                                }
                                write-host 'Disabling WiFi (Wait)'
                                azsphere device wifi disable  -id $id
                                get-anykey '' 'Continue'
                                $id = -1
                            }
                            'F' {
                                if ($id -lt 0)
                                {
                                    write-host "Please Select an Access Point ID first."
                                    get-anykey '' "Continue"
                                    Continue
                                }
                                write-host 'Delete and added WiFi (Wait)'
                                azsphere device wifi forget  -id $id
                                get-anykey '' 'Continue'
                                $id = -1
                            }
                            'A' {
                                $SSID=''
                                $NetworkKey=''
                                write-host 'Getting Wifi Access Points (Wait)'
                                azsphere device wifi scan
                                $SSID = read-host 'Enter SSID of network to use'
                                if (-not ([string]::IsNullOrEmpty($SSID ))) {
                                    $NetworkKey = read-host "Please enter your your newtork key"
                                    if(-not ([string]::IsNullOrEmpty($NetworkKey ))){
                                        write-host 'Adding WifI network (Wait)'
                                        azsphere device wifi add --ssid $SSID --psk $NetworkKey
                                        write-host  'Please note the ID' 
                                        get-anykey '' 'Continue'
                                    }
                                }
                                $SSID=''
                                $NetworkKey=''
                            }
                            'S' {
                                write-host 'Getting Wifi Access Points (Wait)'
                                azsphere device wifi scan
                                get-anykey '' 'Continue'
                            }
                        }
                    } while  ($kk2 -ne 'B')
                }
                'U' {
                    do{
                        show-heading '  A Z U R E  S P H E R E  '  3  'Updates'
                        write-host 'NOTE:'  -BackgroundColor Yellow  -ForegroundColor   Black -nonewline
                        write-host ' ' -nonewline
                        write-host 'This menu requires the Device to be connected.'    -ForegroundColor   DarkRed 
                        write-host ''
                        $options='O. Show OS Version,U. Get Update Status,R. Restart Device,,B.Back'
                        parse-shortlist 'EMPTY'   '   A Z U R E  S P H E R E  '  $options 0 0  2  22 ''
                        $kk2 = [char]::ToUpper($global:kk)
                        $global:kk = $null
                        switch ($kk2){
                        'U' {
                                write-host 'Getting Update Status (Wait):'
                                azsphere device show-deployment-status
                                get-anykey '' 'Continue'
                            }
                        'O' {
                                write-host 'Getting OS Version (Wait):'
                                azsphere device show-os-version
                                get-anykey '' 'Continue'
                            }
                        'R'{
                                write-host 'Restarting device (Wait):'
                                azsphere device enable-development
                                get-anykey '' 'Continue'
                            }
                        }
                    } while ($kk2 -ne 'B')
                }

            }
        }
    } while (($answer -ne 'Back') -and ($answer -ne 'Error'))

    $global:retval = $answer
}
