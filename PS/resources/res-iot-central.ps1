
function get-IOTCentral{
param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$IoTCentralName = '',
    [string]$iotcentralURL = '',
    [string]$IDScope='',
    [string]$DevURL='',
    [bool]$Refresh=$false
)

$IoTCentralName = $global:IoTCentralName
$IoTcentralURL= $global:IoTcentralURL
$IDScope = $global:IDScope
$DevURL=$global:DevURL

function write-app_manifest{
    param (
    [string]$IDScope = '' ,
    [string]$DevURL = '' ,
    [string]$Tenant = '' 
    )

    If ([string]::IsNullOrEmpty($IDScope ))
    {
        write-Host ''
        $prompt =  'Need to get Scope ID first.'
        write-host $prompt
        get-anykey 
        $global:DPS =  'Back'
        return
    }
    elseIf ([string]::IsNullOrEmpty($DevURL ))
    {
        write-Host ''
        $prompt = 'Need to select a Dev ID first.'
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

$BUTTON_A='$BUTTON_A'
$BUTTON_B='$BUTTON_B'
$LED1='$LED1'
$LED2='$LED2'
$NETWORK_CONNECTED_LED='$NETWORK_CONNECTED_LED'
$RELAY='$RELAY'

$data= @"
    {
        "SchemaVersion": 1,
        "Name": "AzureSphereIoTCentral",
        "ComponentId": "25025d2c-66da-4448-bae1-ac26fcdd3627",
        "EntryPoint": "/bin/app",
        "CmdArgs": [ "$IDScope" ],
        "Capabilities": {
          "Gpio": [
            "$BUTTON_A",
            "$BUTTON_B",
            "$LED1",
            "$LED2",
            "$NETWORK_CONNECTED_LED",
            "$RELAY"
          ],
          "Uart": [ "$UART0" ],
          "PowerControls": [ "ForceReboot" ],
          "AllowedConnections": [ "global.azure-devices-provisioning.net","$DevURL"],
          "DeviceAuthentication":  "$Tenant"
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
      write-host "***********************************************************************************"
      write-host ''
      Get-Content -Path $PsScriptFile 
      write-host ''
      write-host "***********************************************************************************"
      write-host "This is for the SEED version of the lab."
      write-host "  This can directly replace app_manifest.json for that."
      write-host "Copy the 3 variables into the app_manifest.json file from here if using other labs."
      write-host "***********************************************************************************"
      write-host ''
      get-anykey '' 'Continue'
}


    show-heading '  A Z U R E  I o T  C E N T R A L  ' 2 '' 
    $Prompt = '     Subscription :"' + $Subscription +'"'
    write-Host $Prompt
    $Prompt = '            Group :"' + $GroupName +'"'
    write-host ' ------------------------------------ '
    $Prompt = ' IoT Central App Name :"' + $Iotcentralname +'"'
    write-Host $Prompt
    $Prompt = '  IoT Central App URL :"' + $IotcentralURL +'"'
    write-Host $Prompt
    $Prompt = '  IoT Central ID Scope :"' + $IDScope+'"'
    write-Host $Prompt
    $Prompt = '   IoT Central Dev URL :"' + $DevURL+'"'
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

    If ([string]::IsNullOrEmpty($global:IoTCentralsStrn ))
    {
        $Refresh=$true
    }



  
    $DPSidscope=$global:DPSidscope

    $DPSStrnIndex =1
    $DPSStrnDataIndex =3

    $Refresh=$false

    do{


        
        $IDScope=$global:IDScope
        $DevURL=$global:DevURL
        $centralappS=$global:IoTCentralsStrn
        $template=$global:IotcentralTemplate
        if ($Refresh)
        {
            write-host "Please wait: Getting IoT Central apps for Group $Groupname from Azure."
            $centralappS = az iot central app list -g $groupname -o tsv | out-string
            $Refresh= $false
            $global:IoTCentralsStrn=$centralappS
            $Iotcentralname = ''
            $IotcentralURL=''
            $global:Iotcentralname=$Iotcentralname
            $global:IotcentralURL=$IotcentralURL
            $IDScope=''
            $DevURL=''
            $global:IDScope=''
            $global:DevURL=''
            $global:IotcentralTemplate=''
        }
    
        $Iotcentralname=$global:Iotcentralname
        $IotcentralURL=$global:IotcentralURL
        $template=$global:IotcentralTemplate
        show-heading '  A Z U R E  I o T  C E N T R A L   ' 2 ''
        $Prompt = '          Subscription :"' + $Subscription +'"'
        write-Host $Prompt
        $Prompt = '                 Group :"' + $GroupName +'"'
        write-Host $Prompt
        write-host ' ------------------------------------ '
        write-Host $Prompt
        $Prompt = '     IoT Central App Name :"' + $Iotcentralname +'"'
        write-Host $Prompt
        $Prompt = '      IoT Central App URL :"' + $IotcentralURL +'"'
        write-Host $Prompt
        $Prompt = '     IoT Central ID Scope :"' + $IDScope+'"'
        write-Host $Prompt
        $Prompt = '      IoT Central Dev URL :"' + $DevURL+'"'
        write-Host $Prompt
        $Prompt = ' IoT Central App Template :"' + $template+'"'
        write-Host $Prompt

        $options ='R. Refresh,C. Create IoT Central App,E. Enter App Name and URL'

        If (-not([string]::IsNullOrEmpty($Iotcentralname )))
        {
            If (-not([string]::IsNullOrEmpty($IotcentralURL )))
            {
                $options="$options,U. Unselect App,S. Show App Details,D. Delete App,O. Open current App,Z. ====================,W. Write app_Manifest.json"
            }
        }
        $options="$options,B. Back"

        If ([string]::IsNullOrEmpty($centralappS ))
        {
            write-Host ''
            $prompt =  'No IoTCentral Apps.'
            write-host $prompt
            $centralappS='EMPTY'
        }
        $val = parse-list $centralappS   '   A Z U R E  I o T  C E N T R A L  A P P '  $options 5 5 1  30 $Iotcentralname $true
        
        if ($centralappS -eq 'EMPTY')
        {
            $centralappS=''
        }

        $answer= $global:retVal 
        $Refresh =$false

        If ([string]::IsNullOrEmpty($answer)) 
        {
            write-Host 'Back'
            $answer = 'Back'
        }
        elseif ($answer -eq $Iotcentralname){
            write-host 'Unchanged'
            $answer=''
        }
        elseif ($global:kk -eq 'R'){
            $Refresh=$true
            $answer=''
        }
        elseif ($global:kk -eq 'O'){
            write-host 'About to open the App Portal.'
            get-yesorno $true "Continue"
            $answer = $global:retVal
            if ( $answer){
                $url = "https://$IotcentralURL"
                start-process $url  
                get-anykey
            }
            $answer=''
        }
        elseif ($global:kk -eq 'U'){
            $Iotcentralname=''
            $IotcentralURL =''
            $global:Iotcentralname = $Iotcentralname
            $global:IotcentralURL = $IotcentralURL
            $IDScope=''
            $DevURL=''
            $global:IDScope=''
            $global:DevURL=''
            $answer=''
        }
        elseif ($answer-eq 'Back')
        {
            write-Host 'Back'
        }
        elseif ($answer-eq 'Error')
        {
            write-Host 'Error'
        }
        elseif ($global:kk -lt '9'){
            $Iotcentralname =$answer
            write-host $Iotcentralname
            get-anykey
            write-host "Please wait. Getting App details from Azure."
            $query =az iot central app show --name $Iotcentralname  -g $global:groupname -o tsv | out-string
            # $query=$global:IoTCentralsStrn
            $subdomain = ($query -split '\t' )[8]
            $IotcentralURL ="$subdomain.azureiotcentral.com"
            $template = ($query -split '\t' )[10]
            $global:IotcentralTemplate = $template
            $global:Iotcentralname = $Iotcentralname
            $global:IotcentralURL = $IotcentralURL
            $answer=''
        }
        else {
            
            $kk2 = [char]::ToUpper($global:kk)
            $global:kk = $null
            switch ($kk2)
            {
                'C' {

                        do { 
                            show-heading '  A Z U R E  S P H E R E  '  4 ' Create IoT Central App ' 
                            $Prompt = '          Subscription :"' + $Subscription +'"'
                            write-Host $Prompt
                            $Prompt = '                 Group :"' + $GroupName +'"'
                            write-host ' ------------------------------------ '
                            $Prompt = '  IoT Central App Name :"' + $Iotcentralname +'"'
                            write-Host $Prompt
                            $Prompt = '   IoT Central App URL :"' + $IotcentralURL +'"'
                            write-Host $Prompt
                            $Prompt = '  IoT Central ID Scope :"' + $IDScope+'"'
                            write-Host $Prompt
                            $Prompt = '   IoT Central Dev URL :"' + $DevURL+'"'
                            write-Host $Prompt
                            $done=$true;
                            $menu='Create here,How to create an IoT Central app in browser,Create in browser - direct'
                            $res = choose-selection $menu 'Select between' 
                            
                            switch ($global:retVal2 ){
                            '2'{
                                write-host 'Just follow the steps on the first page to create a Custom app in the Build Portal.'
                                write-host 'Return here when done to enter the required information.'
                                write-host 'Menu option 3. will take you directly to Build Portal, in future.'
                                get-yesorno $true "Continue"
                                $answer = $global:retVal
                                if ( $answer){
                                    $url = "https://docs.microsoft.com/en-us/azure/iot-central/core/quick-deploy-iot-central"
                                    start-process $url  
                                    get-anykey

                                    $name = read-host "Enter IoT Central app name. Default: $IoTCentralName"
                                    if(-not([string]::IsNullOrEmpty($name )))
                                    {
                                        $IotcentralName= $name.Trim()
                                    }
                                    $global:iotcentralname = $iotcentralname
                                    $IotcentralURL=''
                                    $IotcentralURL = read-host "Enter the URL for the IoT Central. Default: $Iotcentralname.azureiotcentral.com"
                                    $IotcentralURL = $IotcentralURL.Trim()
                                    if([string]::IsNullOrEmpty($IotcentralURL ))
                                    {
                                        $IotcentralURL= "$Iotcentralname.azureiotcentral.com"
                                    }
                                    $global:IotcentralURL = $IotcentralURL
                                }
                            }
                            '3'{
                                write-host "Taking you to the Build Portal"
                                write-host "Return here when you have created the app, only to enter inromation."
                                get-yesorno $true "Continue"
                                $answer = $global:retVal
                                if ($answer){
                                    $url = "https://apps.azureiotcentral.com/build"
                                    start-process $url
                                    get-anykey       
                                    $name = read-host "Enter IoT Central app name. Default: $IoTCentralName"
                                    if(-not([string]::IsNullOrEmpty($name )))
                                    {
                                        $IotcentralName= $name.Trim()
                                    }
                                    $global:iotcentralname = $iotcentralname
                                    $IotcentralURL=''
                                    $IotcentralURL = read-host "Enter the URL for the IoT Central. Default: $Iotcentralname.azureiotcentral.com"
                                    $IotcentralURL = $IotcentralURL.Trim()
                                    if([string]::IsNullOrEmpty($IotcentralURL ))
                                    {
                                        $IotcentralURL= "$Iotcentralname.azureiotcentral.com"
                                    }
                                    $global:IotcentralURL = $IotcentralURL
                                }
                            }
                            '1'{
                                $template = get-iotcentral-template

                                If ([string]::IsNullOrEmpty($template ))
                                {
                                    break
                                }
                                elseif ($template -eq 'Back')
                                {
                                    break
                                }
                                
                                write-host "Template '$template' chosen."
                                $iotcentralname = get-name 'IoT Central App Name';
                                $iotcentralname = $iotcentralname.ToLower()
                                $guid1=new-guid
                                $guid = $guid1.ToString()
                                # $template ="iotc-pnp-preview"
                                $subdomain="$IoTCentralName$guid"
                                # $azquery += --display-name 'My Custom Display Name'
                                    # get-azsphereIOTCentral-custom $global:subscription $global:groupname $global:IoTCentralName
                                    # Need an SKU
                                    $skus = 'F1, S1, ST0, ST1, ST2'
                            
                                    $answer = choose-selection $skus 'SKU' 'S1'
                                    # $answer = $global:retVal
                            
                                    if ([string]::IsNullOrEmpty($answer))
                                    {
                                        $global:retVal = 'Back'
                                        return
                                    }
                                    elseif  ($answer -eq 'Back')
                                    {
                                        $global:retVal = 'Back'
                                        return
                                    }
                            
                                    $SKU = $answer
                                    $SKU =$SKU.Trim()

                                    $locations ='westeurope,westus,eastus2,northeurope,eastus,centralus,westcentralus,australia,asiapacific,europe,japan,uk,unitedstates'
                                    $answer = choose-selection $locations 'Location' 'S1'
                                    # $answer = $global:retVal
                            
                                    if ([string]::IsNullOrEmpty($answer))
                                    {
                                        $global:retVal = 'Back'
                                        return
                                    }
                                    elseif  ($answer -eq 'Back')
                                    {
                                        $global:retVal = 'Back'
                                        return
                                    }
                            
                                    $location = $answer

                                    write-host 'About to run:'
                                    write-host "az iot central app create --subscription $Subscription  --resource-group $GroupName --name $IoTCentralName --subdomain $subdomain   --location $location  --sku $SKU " --template  $template
                                    get-yesorno $true "Continue"
                                    $answer = $global:retVal
                                    if ( $answer)
                                    {
                                        write-host 'Please wait'
                                        az iot central app create --subscription "$Subscription" --resource-group $GroupName --name $IoTCentralName --subdomain $subdomain  --location $location  --sku $SKU     --template  $template
                                        $prompt =  'Done.'
                                        write-host $prompt
                                        get-anykey '' ' Continue.'
                                        $Refresh=$true
                                    }
                                    $global:iotcentralname =$iotcentralname
                                    $iotcentralURL = "https://$subdomain" + '.azureiotcentral.com'
                                    $global:iotcentralURL=$iotcentralURL
                            }   
                            'B'{

                            }
                        }
                        } while (-not $done)
                        $answer=''
                    }              
                
                'E' {  
                        $name = read-host "Enter IoT Central app name. Default: $IoTCentralName"
                        if(-not([string]::IsNullOrEmpty($name )))
                        {
                            $IotcentralName= $name.Trim()
                        }
                        $global:iotcentralname = $iotcentralname
                        $IotcentralURL=''
                        $guid1=new-guid
                        $guid = $guid1.ToString()
                        $IotcentralURL = read-host "Enter the URL for the IoT Central. Default: $Iotcentralname$guid.azureiotcentral.com"
                        $IotcentralURL = $IotcentralURL.Trim()
                        if([string]::IsNullOrEmpty($IotcentralURL ))
                        {
                            $IotcentralURL= "$Iotcentralname$guid.azureiotcentral.com"
                        }
                        $global:IotcentralURL = $IotcentralURL
                    }   
                'D' {  
                        write-host 'Please wait'
                        az iot central app delete --subscription "$Subscription" --resource-group $GroupName --name $IoTCentralName  
                        $Refresh=$true
                        $prompt =  'Done.'
                        write-host $prompt
                        get-anykey '' ' Continue.'
                        $Refresh=$true
                    }   
                'V' {
                        verify-tenant-iotcentral $global:subscription $global:groupname $global:IoTCentralName   $global:IoTCentralURL               
                    }
                'W' {
                        whitelist-iotcentralapp $global:subscription $global:groupname $global:IoTCentralName $global:IoTCentralURL
                        $IDScope=$global:IDScope
                        $DevURL=$global:DevURL
                    }
                'J' {
                        write-app_manifest $Idscope $DevURL $Tenant
                    }
                'S' {
                        write-host "Getting app details from Azure."
                        $name = $global:IoTCentralName.Replace(' ','-')
                        az iot central app show -n $global:IoTCentralName -g $global:groupname -o jsonc
                        get-anykey
                    }

            }
        }
    } while (($answer -ne 'Back') -and ($answer -ne 'Error'))

    $global:retval = $answer
}


# SIG # Begin signature block
# MIIFvQYJKoZIhvcNAQcCoIIFrjCCBaoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUkTxHs4+h6KB6RwPc3vYvTPjA
# LpKgggNLMIIDRzCCAi+gAwIBAgIQa6QCRzY4lrZG+RhikcTxrjANBgkqhkiG9w0B
# AQsFADAnMSUwIwYDVQQDDBxkYXZpZGpvbmVzQHNwb3J0cm9uaWNzLmNvLmF1MB4X
# DTIwMTExOTA3MTY1OVoXDTIxMTExOTA3MzY1OVowJzElMCMGA1UEAwwcZGF2aWRq
# b25lc0BzcG9ydHJvbmljcy5jby5hdTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
# AQoCggEBALuIy+cU+dHYEoYaO2h4ZzyBz344XEcL1jupJJsY/CE1XgqSEVTpFShx
# DYOQbsuSh88Wto/7IYtVY+vqX4rn36pc1rYOLo3EK8kNIhkb3x21R078VnlWWg0D
# Ok3xmuON/iK6FawNjJ7y7fppSqVNTEo2j8I5h51Pssn1PxS86aERWgElnN7jWB+B
# wvwh4zULooQNf+a8/Yd0FlWo1ggM7+hmvUURYa6ueRy+G/LyWwhtWLy9BpitTWRP
# wqjjHlc0/z1qrNc0M139tbszE/v57WCIbZahrZWdbSQvEBXSfqCtCbkLMgEVZ4QX
# MQx017dkfoEKtwxc9AFgZ7IA3Mo4FwkCAwEAAaNvMG0wDgYDVR0PAQH/BAQDAgeA
# MBMGA1UdJQQMMAoGCCsGAQUFBwMDMCcGA1UdEQQgMB6CHGRhdmlkam9uZXNAc3Bv
# cnRyb25pY3MuY28uYXUwHQYDVR0OBBYEFG90a5e0b1NlWeK8Yq9ooDdhrv4aMA0G
# CSqGSIb3DQEBCwUAA4IBAQBenA40fJVqvPdp2R+rTSRaB2iOENA+p99qsYsHp4Gl
# hU49AHneB5Et9lEWd6UBZ+reYcNbitaD/A+4kPOArm6MVxmYL0oc9QKvc2T9z6YY
# O47PKk4NkU3vH2SwygPHD8MlNgpJMO89/u7Sb08Xa5dALGo7VMcPiTNnMji45RMM
# UOPcQBJkzoX6+17JM9Q16qtIZ4Wyl/fEpqqEfnhQsSi+5KpLxD7WNeA43BUx1edC
# gl7PeNfiF4ARlYp4mZykQslg77l02HtRtnEVf74VkzhjBsAcvW60FWMgx2SGcPV1
# zP4UwdFHVyJjXPx//42Zp6AgbCQBcgcl3fSRpxSsObm4MYIB3DCCAdgCAQEwOzAn
# MSUwIwYDVQQDDBxkYXZpZGpvbmVzQHNwb3J0cm9uaWNzLmNvLmF1AhBrpAJHNjiW
# tkb5GGKRxPGuMAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAA
# MBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgor
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBS3jG/lkOK8rVSVl7ypQUiB2HEqlDAN
# BgkqhkiG9w0BAQEFAASCAQAoqSXwW9wyrhOI1XwrYRCEguFwh9BairYIx+c3iBMG
# KQ2QOVeJWOuUK3TyLDZDBC0QgJhJNFEBWLgV+Kkz4JF18qQcxqxsTXL7tyYxqkpN
# sfP4TVrcyzigjXQyNxpmdSTf51lpiZuoOmo1gp6Q6ZmmEf3TFjEVWmw7lqkJ0Sqq
# 3IrVHtginwVFRfa0fU67MdcNzSPnzWvqSEEE3/5nvxCppW0rzIVg+/JpkUB2CMnH
# IDCf4DCEiOBT362RiZs0y3QlKDIpmL0S86CYsKXhK5uu2RIHTu+eGU1SE/s4+Gzr
# 5HZZyCKMj2o6MPYlODu6vm0Hfh446WQqaG1LZRU91bRu
# SIG # End signature block
