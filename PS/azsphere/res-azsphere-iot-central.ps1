
function get-azsphereIOTCentral{
param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$IoTCentralName = '',
    [string]$iotcentralURL = '',
    [string]$IDScope='',
    [string]$DevURL='',
    [bool]$Refresh=$true
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
        "CmdArgsAlt": [$IDScope],
        "CmdArgs": ["--ConnectionType","DPS","--ScopeID","$IDScope"],
        "Capabilities": {
          "GpioAlt": [ "$SAMPLE_BUTTON_1", "$SAMPLE_LED" ],
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


  
    $DPSidscope=$global:DPSidscope

    $DPSStrnIndex =1
    $DPSStrnDataIndex =3


    do{


        
        $IDScope=$global:IDScope
        $DevURL=$global:DevURL
        $Iotcentralname=$global:Iotcentralname
        $IotcentralURL=$global:IotcentralURL

        if ($Refresh){
            write-host "Please wait: Getting IOT Centrals apps for Group $Groupname from Azure."
            $centralappS = az iot central app list -g $groupname -o tsv | out-string
            $Refresh= $false
        }

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

        $options ='C. Create IoT Central App,E. Enter App Name and URL,V. Verify Tenant,W. Whitelist the Azure IoT Central Application Endpoint (2Do),J. Write app_Manifest.json'

        $options="$options,B. Back"

        

        parse-shortlist $centralappS   '   A Z U R E  S P H E R E IoT Central App  '  $options $DPSStrnIndex $DPSStrnIndex 2  22 $Iotcentralname $true
        $answer= $global:retVal
	    read-host $answer
        $Refresh=$false
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
        elseif ($global:kk -lt '9'){
            
            $Iotcentralname =$asnswer
            $IotcentralURL =$answer
            $global:Iotcentralname = $Iotcentralname
            $global:IotcentralURL = $IotcentralURL
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
                            $done=$true;
                            $menu='How ro create IoT Central app in browser,Create in browser,Create using Custom Template,Open Azure Sphere Developer Learning Path Tutorial in browser,Create using Azure Sphere Developer Learning Path'
                            $res = choose-selection $menu 'Select between' 
                            
                            switch ($global:retVal2 ){
                            '1'{
                                write-host 'Just follow the steps on the first page to create a Custom app inteh Build Portal.'
                                write-host 'Return here when done to enter the required information.'
                                write-host 'Menu option 2. will take you directly to Build Portal, in future.'
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
                            '2'{
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
                            '3'{
                                Write-host 'Doing Custom Template'
                                get-yesorno $true "Continue"
                                $answer = $global:retVal
                                if ( $answer)
                                {
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
                            }
                            '4'{
                                $url = "https://github.com/gloveboxes/Azure-Sphere-Learning-Path"
                                start-process $url
                                $done=$false
                            }
                            '5'{
                                Write-host 'Doing Azure Sphere Developer Learning Path Template'
                                get-yesorno $true "Continue"
                                $answer = $global:retVal
                                if ( $answer)
                                {          
                                    create-iotcentral-app $global:subscription $global:groupname $global:IoTCentralName
                                    $iotcentralname = $global:iotcentralname
                                    $iotcentralURL = $global:iotcentralURL
                                }
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
                        $IotcentralURL = read-host "Enter the URL for the IoT Central. Default: $Iotcentralname.azureiotcentral.com"
                        $IotcentralURL = $IotcentralURL.Trim()
                        if([string]::IsNullOrEmpty($IotcentralURL ))
                        {
                            $IotcentralURL= "$Iotcentralname.azureiotcentral.com"
                        }
                        $global:IotcentralURL = $IotcentralURL
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

            }
        }
    } while (($answer -ne 'Back') -and ($answer -ne 'Error'))

    $global:retval = $answer
}
