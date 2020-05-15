
function get-azsphereIOTCentral-custom{
param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$IoTCentralName = '',
    [string]$iotcentralURL = '',
    [string]$IDScope='',
    [string]$DevURL=''
)

$IoTCentralName = $global:IoTCentralName
$IoTcentralURL= $global:IoTCentralName
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


    show-heading '  A Z U R E  S P H E R E  ' 3 'Azure Sphere Developer Learning Path Template' 
    $Prompt = '     Subscription :"' + $Subscription +'"'
    write-Host $Prompt
    $Prompt = '            Group :"' + $GroupName +'"'
    write-host ' ------------------------------------ '
    $Prompt = '          Tenant Name :"' + $TenantName +'"'
    write-Host $Prompt
    $Prompt = '               Tenant :"' + $Tenant +'"'
    write-Host $Prompt
    $Prompt = ' IoT Central App Name :"' + $Iotcentralname +'"'
    write-Host $Prompt
    $Prompt = '  IoT Central App URL :"' + $Iotcentralname.azureiotcentral.com +'"'
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

    $Location =""

    try{
        $groupInfo =  $groupInfo =  az group show --name $groupname -o tsv | out-string
        $Location =  ($groupInfo -split '\t')[1] 
    }
    catch {
        $Location = ''
    }

  
    $DPSidscope=$global:DPSidscope

    $DPSStrnIndex =3
    $DPSStrnDataIndex =5


    do{
        if ($Refresh -eq $true)
        {
            $Refresh=$false
        }
        $IDScope=$global:IDScope
        $DevURL=$global:DevURL
        $IotcentralURL=$global:IotcentralURL

        show-heading '  A Z U R E  S P H E R E  '  3 'Azure Sphere Developer Learning Path Template' 
        $Prompt = '          Subscription :"' + $Subscription +'"'
        write-Host $Prompt
        $Prompt = '                 Group :"' + $GroupName +'"'
        write-host ' ------------------------------------ '
        $Prompt = '           Tenant Name :"' + $TenantName +'"'
        write-Host $Prompt
        $Prompt = '                Tenant :"' + $Tenant +'"'
        write-Host $Prompt
        $Prompt = '  IoT Central App Name :"' + $Iotcentralname +'"'
        write-Host $Prompt
        $Prompt = '   IoT Central App URL :"' + $IotcentralURL +'"'
        write-Host $Prompt
        $Prompt = '  IoT Central ID Scope :"' + $IDScope+'"'
        write-Host $Prompt
        $Prompt = '   IoT Central Dev URL :"' + $DevURL+'"'
        write-Host $Prompt

        $options ='C. Create Custom IoT Central App,E. Enter App Name and URL,V. Verify Tenant,W. Whitelist the Azure IoT Central Application Endpoint (2Do),J. Write app_Manifest.json'

        $options="$options,B. Back"

        parse-shortlist 'EMPTY'   '   A Z U R E  S P H E R E  '  $options $DPSStrnIndex $DPSStrnIndex 2  22  $Current $true
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
                        
                        #Need an SKU
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
                        
                       

                        $iotcentralname = get-name 'IoT Central App Name';
                        $iotcentralname = $iotcentralname.ToLower()
                        $guid1=new-guid
                        $guid = $guid1.ToString()
                        $template ="iotc-pnp-preview"
                        $subdomain="$IoTCentralName$guid"
                        # $azquery += --display-name 'My Custom Display Name'
                        "az iot central app create  --resource-group $GroupName --name $IoTCentralName --subdomain $subdomain   --location $location  --sku $SKU    --template  $template                        "
                        az iot central app create  --resource-group $GroupName --name $IoTCentralName --subdomain $subdomain  --location $location  --sku $SKU    --template  $template


                        $global:iotcentralname =$iotcentralname
                        $iotcentralURL = "https://$subdomain" + '.azureiotcentral.com'
                        $global:iotcentralURL=$iotcentralURL
                    }
                'E' {  
                        $name = read-host "Enter IoT Cenrtral app name. Default: $IoTCentralName"
                        if(-not([string]::IsNullOrEmpty($name )))
                        {
                            $IotcentralName= $name.Trim()
                        }
                        $global:iotcentralname = $iotcentralname
                        
                        if ([string]::IsNullOrEmpty($IotcentralURL))
                        {
                            $IotcentralURL = read-host "Enter the URL for the IoT Central. Default: $Iotcentralname.azureiotcentral.com"
                            $IotcentralURL = $IotcentralURL.Trim()
                            if([string]::IsNullOrEmpty($IotcentralURL ))
                            {
                                $IotcentralURL= "$Iotcentralname.azureiotcentral.com"
                            }
                        } else{
                            $val = read-host "Enter the URL for the IoT Central. Default: $IotcentralURL"
                            $val=$val.Trim()
                            if(-not([string]::IsNullOrEmpty($val )))
                            {
                                $IotcentralURL= $val
                            }
                        } 
                        $global:IotcentralURL = $IotcentralURL
                    }   
                'V' {
                        verify-tenant-iotcentral $global:subscription $global:groupname $global:IoTCentralName  $global:IoTCentralURL                
                    }
                'W' {
                        whitelist-iotcentralapp $global:subscription $global:groupname $global:IoTCentralName $global:IoTCentralURL
                        $IDScope=$global:IDScope
                        $DevURL=$global:DevURL
                    }
                'J' {
                        write-app_manifest $Idscope $DevURL $Tenant
                    }

            }
        }
    } while (($answer -ne 'Back') -and ($answer -ne 'Error'))

    $global:retval = $answer
}
