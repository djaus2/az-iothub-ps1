function write-app_manifest{
    param (
    [string]$ComID = '' ,
    [string]$HubName = '' ,
    [string]$Tenant = '' 
    )

    If ([string]::IsNullOrEmpty($ComID ))
    {
        write-Host ''
        $prompt =  'Need to get DPS Scope ID first.'
        write-host $prompt
        get-anykey 
        $global:DPS =  'Back'
        return
    }
    elseIf ([string]::IsNullOrEmpty($HUbName ))
    {
        write-Host ''
        $prompt = 'Need to select a Hub first.'
        write-host $prompt
        get-anykey 
        $global:DPS =  'Back'
        return
    }
    elseIf ([string]::IsNullOrEmpty($Tenant))
    {
        write-Host ''
        $prompt = 'Need to get the Tenant.'
        write-host $prompt
        get-anykey 
        $global:DPS =  'Back'
        return
    }

$f=@"
    Hello
    World
"@
$SAMPLE_BUTTON_1 ='$SAMPLE_BUTTON_1'
$SAMPLE_BUTTON_2 ='$SAMPLE_BUTTON_2'
$SAMPLE_LED='$SAMPLE_LED'

$data= @"
    {
        "SchemaVersion": 1,
        "Name": "AzureIoT",
        "ComponentId": "819255ff-8640-41fd-aea7-f85d34c491d5",
        "EntryPoint": "/bin/app",
        "CmdArgs": [ "$ComID" ],
        "Capabilities": {
          "AllowedConnections": [ "global.azure-devices-provisioning.net", "$HubName.azure-devices-provisioning.net" ],
          "Gpio": [ "$SAMPLE_BUTTON_1", "$SAMPLE_BUTTON_2", "$SAMPLE_LED" ],
          "DeviceAuthentication": "$Tenant"
        },
        "ApplicationType": "Default"
    }
"@

      $PsScriptFile =  "$global:ScriptDirectory\app_manifest.json"

      $prompt ="Writing app_manifest.json (DPS ID Scope, IoT Hub DNS Name and Tenant) to $PsScriptFile"
      write-host $prompt
      $prompt = "This is a direct replacement for the file in the Azure IoT Sample at https://github.com/Azure/azure-sphere-samples/tree/master/Samples/AzureIoT (IoT Hub modde)."
      write-host $prompt
      get-anykey '' 'Continue'
      Out-File -FilePath $PsScriptFile    -InputObject '' -Encoding ASCII
      Add-Content -Path  $PsScriptFile   -Value $data
}
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

        $options ='P. Azure Sphere Developer Command Prompt (PS Version),L. Login to Azure Sphere,T. Get Tenant,S. Select Tenant,D. Enable Debugging,W. Check Wifi Status,U. Check Update Status,C. Create Certificate,E. New Enrollment Group,I. Get DPS ID Scope,A. Write app_manifest.json'

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
                'P' {   enter-azsphere}
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
                'S' {
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
                'C' {
                        create-azsphere $global:subscription $global:groupname $global:hubname $global:dpsname 
                    }
                'E' {}
                'I' {
                        write-Host ''
                        write-Host "Getting DPS: $DPSName info (Wait) :"
                        $query = az iot dps show --name $DPSName -o json | Out-String | ConvertFrom-Json
                        write-Host "DPS ID Scope:"
                        foreach ($dps in $query) {
                        $DPSidscope = $dps.Properties.idScope
                        }
                        $global:DPSidscope = $DPSidscope
                    }

                'A' {
                        write-app_manifest $DPSidscope $HubName $Tenant
                    }
                'D' {
                        write-host 'Enabling Development (Wait):'
                        azsphere device enable-development
                        get-anykey '' 'Continue'
                    }
                'W' {
                        write-host 'Nb: Command to configure Wifi:'
                        write-host 'azsphere device wifi add --ssid <yourSSID> --psk <yourNetworkKey>'
                        write-host ''
                        write-host 'This command: azsphere device wifi show-status'
                        write-host 'Getting Wifi Status (wait)'
                        azsphere device wifi show-status
                        get-anykey '' 'Continue'
                    }
                'U' {
                        write-host 'Getting Update Status (Wait):'
                        azsphere device show-deployment-status
                        get-anykey '' 'Continue'
                    }

            }
        }
    } while (($answer -ne 'Back') -and ($answer -ne 'Error'))

    $global:retval = $answer
}
