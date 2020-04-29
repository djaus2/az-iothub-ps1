
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


        show-heading '  A Z U R E  S P H E R E  '  3 'Connect Via IoT Hub' 
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

        $options ='D. Get DPS ID Scope,C. Create a Certificate on DPS and verify it,E. Create an Enrolment group on DPS with that certificate,W. Write app_Manifest.json'

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
            
            $kk2 = [char]::ToUpper($global:kk)
            $global:kk = $null
            switch ($kk2)
            {
                'C' {
                        create-azsphere $global:subscription $global:groupname $global:hubname $global:dpsname 
                    }
                'E' {
                        create-enrolmentgroup $global:subscription $global:groupname $global:hubname $global:dpsname $global:DPSCertificateName
                    }
                'D' {
                        show-heading '  A Z U R E  S P H E R E  '  3 'Connect Via IoT Hub - Get DPS ID Scope' 
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
