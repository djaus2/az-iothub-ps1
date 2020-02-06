function trimm{
    param (
    [string]$line = '' 
    )
    $line = $line.Trim()
    $line = ($line -split '\n')[0]
    If ([string]::IsNullOrEmpty($line  )){
        return ''
    }
    if ($line[0] -eq '"' ){
        $line = $line.Substring(1)
        $line = $line.Trim()
    }
    If ([string]::IsNullOrEmpty($line  )){
        return ''
    }
    if ($line[$line.length-1] -eq '"' ){
        $line = $line.Substring(0,$line.length-1 )
        $line = $line.Trim()
    }
    return $line
}

function clear-env{
    $env:IOTHUB_DEVICE_CONN_STRING = $null
    $env:REMOTE_HOST_NAME = $null
    $env:REMOTE_PORT = $null
    $env:IOTHUB_CONN_STRING_CSHARP = $null
    $env:DEVICE_ID = $null
    $env:SHARED_ACCESS_KEY_NAME =$null
    $env:DEVICE_NAME = $null
}

function set-env{
    param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$DeviceName = ''
    )

    #SharedAccesKeyName
    $SharedAccesKeyName = 'iothubowner'
    # $SharedAccesKeyName = 'service'
    write-Host "SharedAccesKeyName is:  $SharedAccesKeyName"
    $env:SHARED_ACCESS_KEY_NAME = $SharedAccesKeyName

    If (-not ([string]::IsNullOrEmpty($DeviceName )))
    {
        write-Host "DeviceName is: $DeviceName" 
        $env:DEVICE_NAME = $DeviceName
    }

    # Device Connection String
    #                             az iot hub device-identity show-connection-string --hub-name {YourIoTHubName} --device-id MyDevice --output table
    #                             az iot hub device-identity show-connection-string --hub-name $HubName --device-id $DeviceName --output table
    write-Host 'Getting IOTHUB_DEVICE_CONN_STRING'
    $cs = az iot hub device-identity show-connection-string --hub-name $HubName --device-id $DeviceName  --output json  | out-string
    $IOTHUB_DEVICE_CONN_STRING = ($cs   | ConvertFrom-Json).connectionString
    write-Host $IOTHUB_DEVICE_CONN_STRING
    $env:IOTHUB_DEVICE_CONN_STRING = $IOTHUB_DEVICE_CONN_STRING 


    # Hub Coonection String
    #                             az iot hub show-connection-string --name $HubName --policy-name iothubowner --key primary  --resource-group $GroupName --output table
    write-host 'Getting IOTHUB_CONN_STRING_CSHARP'
    $cs = az iot hub show-connection-string --name $HubName --policy-name iothubowner --key primary  --resource-group $GroupName --output json  
    $IOTHUB_CONN_STRING_CSHARP = ($cs   | ConvertFrom-Json).connectionString
    write-host $IOTHUB_CONN_STRING_CSHARP
    $env:IOTHUB_CONN_STRING_CSHARP =$IOTHUB_CONN_STRING_CSHARP 

    
    
    # Service Connection string
     write-host 'Getting Service Connection string'
      $cs = az iot hub show-connection-string --policy-name service --name $HubName --output json | out-string
      $SERVICE_CONNECTION_STRING = ($cs   | ConvertFrom-Json).connectionString
      write-host $SERVICE_CONNECTION_STRING
     $env:SERVICE_CONNECTION_STRING = $SERVICE_CONNECTION_STRING

    #DeviceID
    write-host 'DEVICE_ID'
    $DEVICE_ID = $DeviceName
    write-Host $DEVICE_ID
    $env:DEVICE_ID = $DEVICE_ID 



    # EventHubsCompatibleEndpoint
    write-host 'Getting EventHubsCompatibleEndpoint'
    $cs =  az iot hub show --query properties.eventHubEndpoints.events.endpoint --name $HubName --output json |out-string
    $cs = trimm($cs)
    $EventHubsCompatibleEndpoint = $cs.Replace('"','')
    write-host $EventHubsCompatibleEndpoint
    $env:EVENT_HUBS_COMPATIBILITY_ENDPOINT = $EventHubsCompatibleEndpoint
    
    # EventHubsCompatiblePath
    write-host 'Getting EventHubsCompatiblePath'
    $cs = az iot hub show --query properties.eventHubEndpoints.events.path --name $HubName --output json  |out-string
    $cs = trimm $cs
    $EventHubsCompatiblePath = $cs
    write-host $EventHubsCompatiblePath 
    $env:EVENT_HUBS_COMPATIBILITY_PATH =$EventHubsCompatiblePath


    
    # EventHubsSasKey
    write-host 'Getting EventHubsSasKey'
    $cs = az iot hub policy show --name iothubowner --query primaryKey --hub-name $HubName   |out-string
    $cs = trimm $cs
    $EventHubsSasKey = $cs
    write-host  $EventHubsSasKey
    $env:EVENT_HUBS_SAS_KEY=$EventHubsSasKey

    # EventHubsConnectionString
    write-host 'Calculating the Builtin Event Hub-Compatible Endpoint Connection String'
    # Endpoint=sb://<FQDN>/;SharedAccessKeyName=<KeyName>;SharedAccessKey=<KeyValue>
    $cs = "Endpoint=sb://iothub-ns-qwerty-2862278-31b54ca8c2.servicebus.windows.net/;SharedAccessKeyName=iothubowner;SharedAccessKey=kVFKa00TrE6ExALK1CRSviyppoioTXhp4A2O3j5jd4Q=;EntityPath=qwerty"
    $cs = trimm $cs
    $EventHubsConnectionString = $cs
    write-host $EventHubsConnectionString
    $env:EVENT_HUBS_CONNECTION_STRING = $EventHubsConnectionString

    # The next two are only required by Device Streaming Proxy Hub

    # Remote Host Name
    write-host ''
    write-host 'Next two are only required by Device Streaming SSH/RDP Proxy Quickstart.'
    write-host " See https://docs.microsoft.com/en-us/azure/iot-hub/quickstart-device-streams-proxy-csharp"
    write-host 'REMOTE_HOST_NAME'
    $REMOTE_HOST_NAME = "localhost"
    write-host $REMOTE_HOST_NAME
    $env:REMOTE_HOST_NAME = $REMOTE_HOST_NAME

    # Remote Port
    write-host 'REMOTE_PORT'
    $REMOTE_PORT  =  2222
    write-host $REMOTE_PORT 
    $env:REMOTE_PORT = $REMOTE_PORT
    get-anykey
}

function write-env{
    param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$DeviceName = '',
    [string]$folder =''
    )

    $lst = Get-ChildItem $global:ScriptDirectory\Quickstarts  | ?{ $_.PSIsContainer } | Select-Object Name | convertto-csv -NoTypeInformation
    $list2 = $lst -split '\n'
    $menu2 = $list2 | ? {$_.Trim()} | Select-Object -Skip 1
    $menu = {$menu2}.Invoke()
    $menu.Add( 'Quickstarts')
    [string]$itemslist =''
    foreach ($app in $menu) 
    {
        $app2 = $app  -replace '"',''
        if ($app2 -ne 'Common')
        {
            $itemslist += $app2 + ','
        }
    }
    $itemslist = $itemslist.Substring(0, $itemslist.Length-1)
     
    choose-selection $itemslist  'Quickstarts'  ''  ','
    $answer = $global:retVal
    if ($answer -eq 'Back')
    {
        return $answer
    }
    
    $PsScriptFile =  "$global:ScriptDirectory\Quickstarts\set-env.ps1"
    if ($answer -ne 'Quickstarts'){
        $PsScriptFile += "$global:ScriptDirectory\Quickstarts\$answer\set-env.ps1"
    }

    write-host 'Writing to:'
    read-host $PsScriptFile
    Out-File -FilePath $PsScriptFile    -InputObject "" -Encoding ASCII


    #SharedAccesKeyName
    $SharedAccesKeyName = 'iothubowner'
    # $SharedAccesKeyName = 'service'
    write-Host 'SharedAccesKeyName is: ' + $SharedAccesKeyName 
    $op = '$env:SHARED_ACCESS_KEY_NAME = "' + $SharedAccesKeyName +'"'
    Add-Content -Path $PsScriptFile     -Value $op 


    If (-not ([string]::IsNullOrEmpty($DeviceName )))
    {   
        write-Host 'DeviceName is: ' + $DeviceName 
        $op = '$env:DEVICE_NAME = "' + $DeviceName +'"'
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
    }
    else{
        $IOTHUB_DEVICE_CONN_STRING=$env:IOTHUB_DEVICE_CONN_STRIN
    }
    write-Host $IOTHUB_DEVICE_CONN_STRING
    $op = '$env:IOTHUB_DEVICE_CONN_STRING = "' + $IOTHUB_DEVICE_CONN_STRING +'"'
    Add-Content -Path $PsScriptFile     -Value $op -
 


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
    write-host $IOTHUB_CONN_STRING_CSHARP
    $op = '$env:IOTHUB_CONN_STRING_CSHARP = "' +$IOTHUB_CONN_STRING_CSHARP +'"'
    Add-Content -Path  $PsScriptFile -Value $op
    
    
    # Service Connection string
     write-host 'Getting Service Connection string'
    If ([string]::IsNullOrEmpty($env:SERVICE_CONNECTION_STRING ))
    {  
        $cs = az iot hub show-connection-string --policy-name service --name $HubName --output json | out-string
        $SERVICE_CONNECTION_STRING = ($cs   | ConvertFrom-Json).connectionString
    } else{
        $SERVICE_CONNECTION_STRING = $env:SERVICE_CONNECTION_STRING
    }
    write-host $SERVICE_CONNECTION_STRING
    $op = '$env:SERVICE_CONNECTION_STRING = "' + $SERVICE_CONNECTION_STRING +'"'
    Add-Content -Path  $PsScriptFile -Value $op

    #DeviceID
    write-host 'DEVICE_ID'
    $DEVICE_ID = $DeviceName
    write-Host $DEVICE_ID
    $op = '$env:DEVICE_ID = "' + $DEVICE_ID +'"'
    Add-Content -Path  $PsScriptFile  -Value $op



    # EventHubsCompatibleEndpoint
    If ([string]::IsNullOrEmpty($env:EventHubsCompatibleEndpoint ))
    {  
    write-host 'Getting EventHubsCompatibleEndpoint'
    $cs =  az iot hub show --query properties.eventHubEndpoints.events.endpoint --name $HubName --output json |out-string
    $cs = trimm $cs
    $EventHubsCompatibleEndpoint = $cs
    }else{
        $EventHubsCompatibleEndpoint =   $env:EventHubsCompatibleEndpoint 
    }
    write-host $EventHubsCompatibleEndpoint
    $op = '$env:EVENT_HUBS_COMPATIBILITY_ENDPOINT = "' + $EventHubsCompatibleEndpoint +'"'
    Add-Content -Path  $PsScriptFile  -Value $op
    
    # EventHubsCompatiblePath
    write-host 'Getting EventHubsCompatiblePath'
    $cs = az iot hub show --query properties.eventHubEndpoints.events.path --name $HubName --output json  |out-string
    $cs = trimm $cs
    $EventHubsCompatiblePath = $cs
    write-host $EventHubsCompatiblePath 
    $op = '$env:EVENT_HUBS_COMPATIBILITY_PATH = "' + $EventHubsCompatiblePath +'"'
    Add-Content -Path  $PsScriptFile  -Value $op


    
    # EventHubsSasKey
    write-host 'Getting EventHubsSasKey'
    $cs = az iot hub policy show --name iothubowner --query primaryKey --hub-name $HubName   |out-string
    $cs = trimm $cs
    $EventHubsSasKey = $cs
    write-host  $EventHubsSasKey
    $op = '$env:EVENT_HUBS_SAS_KEY = "' + $EventHubsSasKey +'"'
    Add-Content -Path  $PsScriptFile  -Value $op


    # EventHubsConnectionString
    write-host 'Calculating the Builtin Event Hub-Compatible Endpoint Connection String'
    # Endpoint=sb://<FQDN>/;SharedAccessKeyName=<KeyName>;SharedAccessKey=<KeyValue>
    $cs = "Endpoint=sb://iothub-ns-qwerty-2862278-31b54ca8c2.servicebus.windows.net/;SharedAccessKeyName=iothubowner;SharedAccessKey=kVFKa00TrE6ExALK1CRSviyppoioTXhp4A2O3j5jd4Q=;EntityPath=qwerty"
    $EventHubsConnectionString = $cs
    write-host $EventHubsConnectionString
    $op = '$env:EVENT_HUBS_CONNECTION_STRING = "' + $EventHubsConnectionString +'"'
    Add-Content -Path  $PsScriptFile  -Value $op

    # The next two are only required by Device Streaming Proxy Hub

    # Remote Host Name
    #write-host ''
    #write-host 'Next two are only required by Device Streaming SSH/RDP Proxy Quickstart.'
    #write-host " See https://docs.microsoft.com/en-us/azure/iot-hub/quickstart-device-streams-proxy-csharp"
    #write-host 'REMOTE_HOST_NAME'
    $REMOTE_HOST_NAME = "localhost"
    #write-host $REMOTE_HOST_NAME
    $op = '$env:REMOTE_HOST_NAME = "' + $REMOTE_HOST_NAME +'"'
    Add-Content -Path  $PsScriptFile  -Value $op

    # Remote Port
    # write-host 'REMOTE_PORT'
    $REMOTE_PORT  =  2222
    # write-host $REMOTE_PORT 
    $op =  '$env:REMOTE_PORT = ' + $REMOTE_PORT
    Add-Content -Path  $PsScriptFile -Value $op

    write-Host "Written PowerShell script to:  $PsScriptFile that will set the Hub connection strings as Env. Vars"


    
    # write-host 'Writing ps script to root of apps to simultaneously run both apps  as run-apps.ps1'
    # Out-File -FilePath $PsScriptFile    -InputObject '.\set-env' -Encoding ASCII
    # Add-Content -Path  $PsScriptFile   -Value 'cd device'
    # Add-Content -Path  $PsScriptFile   -Value 'Start-process dotnet run'
    # Add-Content -Path  $PsScriptFile   -Value 'cd ..\service' 
    # Add-Content -Path  $PsScriptFile   -Value 'start-process dotnet run'
    # Add-Content -Path  $PsScriptFile   -Value 'cd ..'
    # get-anykey
}










