
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
$IoTcentralURL= $global:IoTCentralURL
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
    $Refresh=$false

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

        $options ='C. Create IoT Central App,E. Enter App Name and URL,V. Verify Tenant,W. Whitelist the Azure IoT Central Application Endpoint (2Do),J. Write app_Manifest.json,R. Refresh App List'

        $options="$options,B. Back"

        If ([string]::IsNullOrEmpty($centralappS ))
        {
            write-Host ''
            $prompt =  'No IoTCentral Apps.'
            write-host $prompt
            $centralappS='EMPTY'
        }
        $res = parse-shortlist $centralappS   '   A Z U R E  S P H E R E IoT Central App  '  $options $DPSStrnIndex $DPSStrnIndex 2  22 $Iotcentralname $true
        if ($centralappS -eq 'EMPTY')
        {
            $centralappS=''
        }
        
        $answer= $global:retVal
	    
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
            $Iotcentralname =$answer
            write-host "Please wait. Getting info for $Iotcentralname from Azure"
            $info = az iot central app show --name $Iotcentralname --resource-group $GroupName |  ConvertFrom-Json
            write-host 'App Info:'
            write-host $info.displayName
            write-host $info.applicationId
            write-host $info.etag
            write-host $info.resourceGroup
            write-host $info.name
            write-host $info.subdomain
            write-host $info.template
            write-host $info.location
            write-host $info.sku
            get-anykey
            $IDScope =$info.applicationId
            $IotcentralURL =$info.subdomain + '.azureiotcentral.com'
            $global:IDScope = $IDScope
            $global:Iotcentralname = $Iotcentralname
            $global:IotcentralURL = $IotcentralURL
        }
        else {
            
            $kk2 = [char]::ToUpper($global:kk)
            $global:kk = $null
            switch ($kk2)
            {

                'R' { $Refresh=$true}
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
                            $menu='Create using Custom Template,Create in browser'
                            # Open Azure Sphere Developer Learning Path Tutorial in browser,Create using Azure Sphere Developer Learning Path'
                            $res = choose-selection $menu 'Select between' 
                            
                            switch ($global:retVal2 ){
                            '2'{
                                $apps=$null
                                $apps = Get-Content "$global:ScriptDirectory\iotcentralappz.json" | ConvertFrom-Json
                                $appnames=''
                                foreach ($x in $apps)
                                {
                                    $appnames += $x.displayname +','
                                }
                                $res = choose-selection $appnames  'Select the IoTCetralapp to create.'
                                if ($res -eq 'Back')
                                {
                                    break
                                }
                                $name = $apps[$global:retValNum-1].displayname
                                $url = $apps[$global:retValNum-1].url
                                write-host ''
                                write-host "App:$name  Url:$url"
                                write-host "Nb: You can add more apps to PS\iotcentralapps.json"
                                write-host "Taking you to the Build Portal"
                                write-host "============="
                                write-host "Nb: Apps created in the Portal belong to the group IOTC"
                                write-host ''
                                $GroupName ='IOTC'
                                $HubName =''
                                $DPSName =''
                                $Device=''
                                $global:GroupName ='IOTC'
                                $global:HubName =''
                                $global:DPSName =''
                                $global:Device=''
                                write-host "Return here when you have created the app, to get app information."
                                get-yesorno $true "Continue"
                                $answer = $global:retVal
                                if ($answer){
                                    start-process $url
                                    get-anykey       
                                    $name = read-host "Enter IoT Central app Dashboard Url."
                                    if(-not([string]::IsNullOrEmpty($name )))
                                    {
                                        $name= $name.Trim()
                                    }
                                    $name=$name.replace("/dashboards/urn:homepageView:els1mecc", "")
                                    $name=$name.replace("https://","")
                                    $name=$name.replace(".azureiotcentral.com","")
                                    $iotcentralname =$name
                                    $global:iotcentralname = $iotcentralname
                                    write-host "Please wait. Getting info for $Iotcentralname from Azure"
                                    $info = az iot central app show --name $Iotcentralname --resource-group $GroupName |  ConvertFrom-Json
                                    write-host 'App Info:'
                                    write-host $info.displayName
                                    write-host $info.applicationId
                                    write-host $info.etag
                                    write-host $info.resourceGroup
                                    write-host "====="
                                    write-host $info.name
                                    write-host $info.subdomain
                                    write-host $info.template
                                    write-host $info.location
                                    write-host $info.sku
                                    get-anykey
                                    $IDScope =$info.applicationId
                                    $IotcentralURL =$info.subdomain + '.azureiotcentral.com'
                                    $global:IDScope = $IDScope
                                    $global:Iotcentralname = $Iotcentralname
                                    $global:IotcentralURL = $IotcentralURL
                                }
                            }
                            '1'{
                                $template = 'iotc-pnp-preview'
                                Write-host 'Doing Custom Template xx'
                                get-yesorno $true "Continue"
                                $answer = $global:retVal
                                if ( $answer)
                                {
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
                                        $Refresh=$true
                                        write-host "Please wait. Getting info for $Iotcentralname from Azure"
                                        $info = az iot central app show --name $Iotcentralname --resource-group $GroupName |  ConvertFrom-Json
                                        write-host 'App Info:'
                                        write-host $info.displayName
                                        write-host $info.applicationId
                                        write-host $info.etag
                                        write-host $info.resourceGroup
                                        write-host $info.name
                                        write-host $info.subdomain
                                        write-host $info.template
                                        write-host $info.location
                                        write-host $info.sku
                                        get-anykey
                                        $IDScope =$info.applicationId
                                        $IotcentralURL =$info.subdomain + '.azureiotcentral.com'
                                        $global:IDScope = $IDScope
                                        $global:Iotcentralname = $Iotcentralname
                                        $global:IotcentralURL = $IotcentralURL
                                    }
                                    # $global:iotcentralname =$iotcentralname
                                    # $iotcentralURL = "https://$subdomain" + '.azureiotcentral.com'
                                    # $global:iotcentralURL=$iotcentralURL
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
