
function get-azsphereDPS{
param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$DPSName = '',
    [string]$Tenant='',
    [String]$TenantName='',
    [boolean]$Refresh=$false
)

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
        "CmdArgsOld": [ "$ComID" ],
        "CmdArgs": [ "--ConnectionType", "DPS", "--ScopeID", "$ComID" ],
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

    $DPSCertificateName = $global:DPSCertificateName

    show-heading '  A Z U R E  S P H E R E  ' 3 'Connect Via IoT Hub' 
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
    $Prompt = ' DPSCertificateName :"' + $DPSCertificateName
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
    elseIf ([string]::IsNullOrEmpty($Tenant ))
    {
        write-Host ''
        $prompt = 'Need to get Tenant first.'
        write-host $prompt
        get-anykey 
        $global:DPS =  'Back'
        return
    }
    elseIf ([string]::IsNullOrEmpty($TenantName ))
    {
        write-Host ''
        $prompt = 'Need to get Tenant first.'
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


        show-heading '  A Z U R E  S P H E R E  '  3 'Connect Via IoT Hub and DPS' 
        $Prompt = '       Subscription :"' + $Subscription +'"'
        write-Host $Prompt
        $Prompt = '              Group :"' + $GroupName +'"'
        write-Host $Prompt
        $Prompt = '                Hub :"' + $HubName +'"'
        write-Host $Prompt
        $Prompt = '                DPS :"' + $DPSName +'"'
        write-Host $Prompt
        write-host ' -------------------------------------- '
        $Prompt = '        Tenant Name :"' + $TenantName +'"'
        write-Host $Prompt
        $Prompt = '             Tenant :"' + $Tenant +'"'
        write-Host $Prompt
        $Prompt = '       DPS ID Scope :"' + $DPSIdScope +'"'
        write-Host $Prompt
        $Prompt = '   IoT Hub DNS Name :"' + $HubName + '.azure-devices-provisioning.net"'
        write-Host $Prompt
        $Prompt = ' DPSCertificateName :"' + $DPSCertificateName +'"'
        write-Host $Prompt

        $options ="D. Get DPS ID Scope,C. Create a Certificate on DPS and verify it,E. Create an Enrolment group on DPS with that certificate,W. Write app_Manifest.json"
        $options +=",M. Misc Actions: ==========="
        $options +=",L. List and select one of the DPS's Certificates,N. Set DPS Certificate Name,S. Show Certifcate,X. Clear DPS Certificate Name,R. Delete DPS Certificate"

        $options="$options,B. Back"

        $answer = parse-shortlist 'EMPTY'   '   A Z U R E  S P H E R E  D P S  '  $options $DPSStrnIndex $DPSStrnIndex 2  22 $Current $true
        $answer= $global:retVal

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
            
            $kk2 = [char]::ToUpper($global:kk)
            $global:kk = $null
            switch ($kk2)
            {
                'C' {
                        create-azsphere $global:subscription $global:groupname $global:hubname $global:dpsname $global:DPSCertificateName
                    }
                'N' {

                        $answer = get-name 'DPS Certificate Name'
                        if ($answer-eq 'Back')
                        {

                        }
                        else
                        {
                            $DPSCertificateName = $answer
                            $global:DPSCertificateName = $DPSCertificateName
                        }
                    
                    }
                'L' { 
                        write-host "Please wait. Getting Certificates."
                        $x = az iot dps certificate list --dps-name $global:dpsname  --resource-group $global:groupname -o json | ConvertFrom-Json
                        $n = $x.value.length
                        if ($n -ne 0)
                        {
                            # $z = $x.value | Select name
                            $list =''
                            foreach ($v in $x.value)
                            {
                                $name = $v.name
                                $list += $name + ','
                            }
                            $res = choose-selection $list '  A Z U R E  S P H E R E  DPS Certificates  ' $DPSCertificateName
                            $res = $global:retVal
                            If (-not ([string]::IsNullOrEmpty($res )))
                            {
                                if (-not ($res -eq 'Back'))
                                {
                                    $DPSCertificateName= $res
                                    $global:DPSCertificateName = $DPSCertificateName
                                }
                                else {
                                    write-host "No certificate selected 2."
                                    get-anykey
                                }
                            }
                            else {
                                write-host "No certificate selected 1."
                                get-anykey
                            }
                        }
                        else {
                            write-host "No certificates."
                            get-anykey
                        }
                    }
                'S' {
                    If (-not ([string]::IsNullOrEmpty($global:DPSCertificateName )))
                    {
                        write-host "Please wait. Getting certificate info."
                        az iot dps certificate show --dps-name $global:dpsname --resource-group $global:groupname --certificate-name $global:DPSCertificateName -o jsonc
                        get-anykey
                    }
                    else 
                    {
                        write-host "No DPS Certicate name."
                        get-anykey
                    }
                }
                'X' {
                        If (-not([string]::IsNullOrEmpty($global:DPSCertificateName )))
                        {
                            $DPSCertificateName = ''
                            $global:DPSCertificateName = $DPSCertificateName
                        }
                    }
                'R' {
                        If (-not ([string]::IsNullOrEmpty($global:DPSCertificateName )))
                        {
                            write-host "Please wait. Getting certificate info."
                            $cert = az iot dps certificate show --dps-name $global:dpsname --resource-group $global:groupname --certificate-name $global:DPSCertificateName -o tsv | Out-String
                            If (-not ([string]::IsNullOrEmpty($cert )))
                            {
                                $infos =   $cert -split '\t'
                                if ($infos.Length -gt 0)
                                {
                                    $etag = $infos[0]
                                    If (-not([string]::IsNullOrEmpty($etag )))
                                    {                                
                                        write-Host "etag: " + $etag
                                        # write-host "az iot dps certificate delete --dps-name $global:dpsname  --resource-group $global:groupname  --certificate-name $global:DPSCertificateName --etag $etag"
                                        # get-anykey
                                        write-host "Please wait. Deleting certifcate"
                                        az iot dps certificate delete --dps-name $global:dpsname  --resource-group $global:groupname  --certificate-name $global:DPSCertificateName --etag $etag
                                        $DPSCertificateName = ''
                                        $global:DPSCertificateName = $DPSCertificateName
                                        get-anykey 'Done' 'Press any key to continue'
                                    }
                                    else {
                                        write-host "Certificate etag not found."
                                        get-anykey
                                    }
                                }
                                else {
                                    write-host "Certificate not found."
                                    get-anykey
                                }
                            }
                        }
                        else 
                        {
                            write-host "No DPS Certicate name."
                            get-anykey
                        }
                    }
                'E' {
                        create-enrolmentgroup $global:subscription $global:groupname $global:hubname $global:dpsname $global:DPSCertificateName
                        # az iot dps enrollment-group create  -g $global:groupname  --dps-name $global:dpsname --ca-name  $global:DPSCertificateName  --enrollment-id $GroupName
                    }
                'D' {
                        show-heading '  A Z U R E  S P H E R E  '  3 'Connect Via IoT Hub and DPS - Get DPS ID Scope' 
                        write-Host ''
                        write-Host "Getting DPS: $DPSName info (Wait) :"
                        $query = az iot dps show --name $DPSName -o json | Out-String | ConvertFrom-Json
                        write-Host "DPS ID Scope:"
                        foreach ($dps in $query) {
                        $DPSidscope = $dps.Properties.idScope
                        }
                        $global:DPSidscope = $DPSidscope
                        write-host "DPS ID Scope: $DPSidscope"
                        get-anykey '' 'Continue'
                    }

                'W' {
                        write-app_manifest $DPSidscope $HubName $Tenant
                    }

            }
        }
    } while (($answer -ne 'Back') -and ($answer -ne 'Error'))

    $global:retval = $answer
}
