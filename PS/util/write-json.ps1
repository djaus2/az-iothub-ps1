function write-json{
    param (
    [string]$Subscription='' ,
    [string]$GroupName='' ,
    [string]$HubName='' ,
    [string]$DeviceName='',
    [string]$foldernameIn =''
    )

    $answer=$foldernameIn
    $folderName = $folderNameIn
    $doingOuterFolder = $false

    show-heading '  W R I T E   E N V I R O N M E N T  V A R S to  L a u n c h s e t t i n g s  J S O N  F I L E  ' 3
    write-host ''
    $prompt =  'Do you want to regenerate the environment variables?'
    write-Host $prompt
    get-yesorno $true
    $response = $global:retVal
    if ($response){
        set-env $Subscription $GroupName $HubName $DeviceName 
    }
    
    do {
    show-heading '  W R I T E   E N V I R O N M E N T  V A R S to  L a u n c h s e t t i n g s  J S O N  F I L E  ' 3
    
    If  ([string]::IsNullOrEmpty($foldernameIn))
    {
        $foldernameIn ="" 
        if (!$doingOuterFolder)
        {
            show-quickstarts 'Quickstart Projects folder.' 'Quickstarts,ScriptHostRoot'
            $foldernameMaster =  $global:retVal1
            $answerMaster = $global:retVal
        }
        $foldername =  $foldernameMaster
        $answer = $answerMaster

        if ($answer -eq 'Back')
        {
            return $answer
        }

        if ($answer.ToLower() -eq 'quickstarts'){
            $PsScriptFile = "$global:ScriptDirectory\qs-apps\quickstarts\launchSettings.json"
            $doingOuterFolder = $false
        }
        elseif ($answer.ToLower() -eq 'scripthostroot'){
            $PsScriptFile = "$global:ScriptDirectory\launchSettings.json"
            $doingOuterFolder = $false
        } else {


            $doingOuterFolder = $true
            show-heading '  W R I T E   E N V I R O N M E N T  V A R S to  L a u n c h s e t t i n g s  J S O N  F I L E  ' 3
            select-subfolder $answer "app from the Quickstart: $folderName"
            $answer = $global:retVal
            if ($answer -eq 'Back')
            {
                return $answer
            }

            $foldername =  $global:retVal1
            $answer = $global:retVal

            $PsScriptFile = "$answer\Properties\launchSettings.json"
            
            $path = "$answer\Properties"
            If (!(test-path $path ))
            {
                New-Item -ItemType Directory -Path $path
            }

        }

        show-heading '  W R I T E   E N V I R O N M E N T  V A R S to  L a u n c h s e t t i n g s  J S O N  F I L E  ' 3
    }




    $prompt =  "Writing Env Vars to: $PsScriptFile"
    get-anykey $prompt 'Continue' $false
   
    $op= "{"
    Out-File -FilePath $PsScriptFile     -InputObject $op -Encoding ASCII
    $op = '    "profiles": {'
    Add-Content -Path $PsScriptFile     -Value $op
    $op = '      "' + "$foldername" + '": {'
    Add-Content -Path $PsScriptFile     -Value $op
    $op = '        "commandName": "Project",'
    Add-Content -Path $PsScriptFile     -Value $op
    $op = '        "environmentVariables": {'
    Add-Content -Path $PsScriptFile     -Value $op


    

    #SharedAccesKeyName
    $SharedAccesKeyName='iothubowner'
    # $SharedAccesKeyName='service'
    write-Host "1. SHARED_ACCESS_KEY_NAME:$SharedAccesKeyName" 
    $op = '            "SHARED_ACCESS_KEY_NAME":"' +"$SharedAccesKeyName" +'",'
    Add-Content -Path $PsScriptFile     -Value $op
    
    If (-not ([string]::IsNullOrEmpty($DeviceName )))    
    {   
        write-Host "2. DEVICE_NAME:$DeviceName"
        $op = '            "DEVICE_NAME":"' +"$DeviceName" +'",'
        Add-Content -Path $PsScriptFile     -Value $op 
    }    
    # Device Connection String
    #                             az iot hub device-identity show-connection-string --hub-name {YourIoTHubName} --device-id MyDevice --output table
    #                             az iot hub device-identity show-connection-string --hub-name $HubName --device-id $DeviceName --output table
    If ([string]::IsNullOrEmpty($env:IOTHUB_DEVICE_CONN_STRING ))
    {      
        write-Host 'Getting IOTHUB_DEVICE_CONN_STRING'
        $cs = az iot hub device-identity show-connection-string --hub-name $HubName --device-id $DeviceName  --output json  | out-string
        $IOTHUB_DEVICE_CONN_STRING = ($cs   | ConvertFrom-Json).connectionString
    }else{
        $IOTHUB_DEVICE_CONN_STRING=$env:IOTHUB_DEVICE_CONN_STRING
    }
    write-Host "3. IOTHUB_DEVICE_CONN_STRING:$IOTHUB_DEVICE_CONN_STRING"
    $op = '            "IOTHUB_DEVICE_CONN_STRING":"' +"$IOTHUB_DEVICE_CONN_STRING" +'",'
    Add-Content -Path $PsScriptFile   -Value $op 
 


    # Hub Coonection String
    #                             az iot hub show-connection-string --name $HubName --policy-name iothubowner --key primary  --resource-group $GroupName --output table
    If ([string]::IsNullOrEmpty($env:IOTHUB_CONN_STRING_CSHARP ))
    {   
         write-host 'Getting IOTHUB_CONN_STRING_CSHARP'
         $cs = az iot hub show-connection-string --name $HubName --policy-name iothubowner --key primary  --resource-group $GroupName --output json  
         $IOTHUB_CONN_STRING_CSHARP = ($cs   | ConvertFrom-Json).connectionString
    } else{
        $IOTHUB_CONN_STRING_CSHARP = $env:IOTHUB_CONN_STRING_CSHARP
    }
    write-host "4. IOTHUB_CONN_STRING_CSHARP =  $IOTHUB_CONN_STRING_CSHARP"
    $op = '            "IOTHUB_CONN_STRING_CSHARP":"' +"$IOTHUB_CONN_STRING_CSHARP" +'",'
    Add-Content -Path  $PsScriptFile -Value $op
    
    
    # Service Connection string

    If ([string]::IsNullOrEmpty($env:SERVICE_CONNECTION_STRING ))
    { 
        write-host 'Getting Service Connection string'
        $cs = az iot hub show-connection-string --policy-name service --name $HubName --output json | out-string
        $SERVICE_CONNECTION_STRING = ($cs   | ConvertFrom-Json).connectionString
    } else{
        $SERVICE_CONNECTION_STRING = $env:SERVICE_CONNECTION_STRING
    }
    write-host "5. SERVICE_CONNECTION_STRING:$SERVICE_CONNECTION_STRING"
    $op = '            "SERVICE_CONNECTION_STRING":"' +"$SERVICE_CONNECTION_STRING" +'",'
    Add-Content -Path  $PsScriptFile  -Value $op

    #DeviceID
    $DEVICE_ID = $DeviceName
    write-Host "6. DEVICE_ID:$DEVICE_ID"
    $op = "DEVICE_ID:'$DEVICE_ID',"
    $op = '            "DEVICE_ID":"' +"$DEVICE_ID" +'",'
    Add-Content -Path  $PsScriptFile  -Value $op



    # EventHubsCompatibleEndpoint
    If ([string]::IsNullOrEmpty($env:EVENT_HUBS_COMPATIBILITY_ENDPOINT ))
    {  
    write-host 'Getting EventHubsCompatibleEndpoint'
    $cs =  az iot hub show --query properties.eventHubEndpoints.events.endpoint --name $HubName --output json |out-string
    $cs = trimm $cs
    $EventHubsCompatibleEndpoint = $cs
    }else{
        $EventHubsCompatibleEndpoint =   $env:EVENT_HUBS_COMPATIBILITY_ENDPOINT
    }
    write-host "7. EVENT_HUBS_COMPATIBILITY_ENDPOINT:$EventHubsCompatibleEndpoint"
    $op = '            "EVENT_HUBS_COMPATIBILITY_ENDPOINT":"' +"$EventHubsCompatibleEndpoint" +'",'
    Add-Content -Path  $PsScriptFile  -Value $op
    
    # EventHubsCompatiblePath
    If ([string]::IsNullOrEmpty($env:EVENT_HUBS_COMPATIBILITY_PATH ))
    {  
        write-host 'Getting EventHubsCompatiblePath'
        $cs = az iot hub show --query properties.eventHubEndpoints.events.path --name $HubName --output json  |out-string
        $cs = trimm $cs
        $EventHubsCompatiblePath = $cs
    } else {
        $EventHubsCompatiblePath = $env:EVENT_HUBS_COMPATIBILITY_PATH
    }
    write-host "8. EVENT_HUBS_COMPATIBILITY_PATH:$EventHubsCompatiblePath"
    $op = '            "EVENT_HUBS_COMPATIBILITY_PATH":"' +"$EventHubsCompatiblePath" +'",'
    Add-Content -Path  $PsScriptFile  -Value $op


    
    # EventHubsSasKey
    If ([string]::IsNullOrEmpty($env:EVENT_HUBS_SAS_KEY ))
    {  
        write-host 'Getting EventHubsSasKey'
        $cs = az iot hub policy show --name iothubowner --query primaryKey --hub-name $HubName   |out-string
        $cs = trimm  $cs
        $EventHubsSasKey = $cs
    } else {
        $EventHubsSasKey = $env:EVENT_HUBS_SAS_KEY 
    }
    write-host  "9. EVENT_HUBS_SAS_KEY:$EventHubsSasKey"
    $op = '            "EVENT_HUBS_SAS_KEY":"' +"$EventHubsSasKey" +'",'
    
    Add-Content -Path  $PsScriptFile  -Value $op

    # EventHubsConnectionString
    write-host 'Calculating the Builtin Event Hub-Compatible Endpoint Connection String'
    # Endpoint=sb://<FQDN>/;SharedAccessKeyName=<KeyName>;SharedAccessKey=<KeyValue>
    $cs = "Endpoint=sb://iothub-ns-qwerty-2862278-31b54ca8c2.servicebus.windows.net/;SharedAccessKeyName=iothubowner;SharedAccessKey=kVFKa00TrE6ExALK1CRSviyppoioTXhp4A2O3j5jd4Q=;EntityPath=qwerty"
    $EventHubsConnectionString = $cs
    write-host "10. EVENT_HUBS_CONNECTION_STRING:$EventHubsConnectionString"
    $op = '            "EVENT_HUBS_CONNECTION_STRING":"' +"$EventHubsConnectionString" +'",'
    Add-Content -Path  $PsScriptFile  -Value $op

    # The next two are only required by Device Streaming Proxy Hub


    $REMOTE_HOST_NAME = "localhost"
    write-host "11. REMOTE_HOST_NAME:$REMOTE_HOST_NAME"
    $op = '            "REMOTE_HOST_NAME":"'+ "$REMOTE_HOST_NAME" +'",'
    Add-Content -Path  $PsScriptFile  -Value $op

    # Remote Port
    $REMOTE_PORT  =  2222
    write-host "12. REMOTE_PORT = $REMOTE_PORT"
    $op =  '            "REMOTE_PORT":"' +"$REMOTE_PORT" +'"'
    Add-Content -Path  $PsScriptFile  -Value $op

    $op = '      }'
    Add-Content -Path $PsScriptFile     -Value $op
    $op = '    }'
    Add-Content -Path $PsScriptFile     -Value $op
    $op = '  }'
    Add-Content -Path $PsScriptFile     -Value $op
    $op = '}'
    Add-Content -Path $PsScriptFile     -Value $op

    write-Host "Written Json file to:  $PsScriptFile that will set the Hub connection strings as Env. Vars"
    get-anykey

    } while ($doingOuterFolder)

}









