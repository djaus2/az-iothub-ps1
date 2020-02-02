function clear-env{
    $env:IOTHUB_DEVICE_CONN_STRING = $null
    $env:REMOTE_HOST_NAME = $null
    $env:REMOTE_PORT = $null
    $env:IOTHUB_CONN_STRING_CSHARP = $null
    $env:DEVICE_ID = $null
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

    # Remote Host Name
    write-host 'REMOTE_HOST_NAME'
    $REMOTE_HOST_NAME = ""
    write-host $REMOTE_HOST_NAME
    $env:REMOTE_HOST_NAME = $REMOTE_HOST_NAME

    # Remote Port
    write-host 'REMOTE_PORT'
    $REMOTE_PORT  =""
    write-host $REMOTE_PORT 
    $env:REMOTE_PORT = $REMOTE_PORT


    #DeviceID
    write-host 'DEVICE_ID'
    $DEVICE_ID = $DeviceName
    write-Host $DEVICE_ID
    $env:DEVICE_ID = $DEVICE_ID 



    # EventHubsCompatibleEndpoint
    write-host 'Getting EventHubsCompatibleEndpoint'
    $cs =  az iot hub show --query properties.eventHubEndpoints.events.endpoint --name $HubName --output json |out-string
    $cs = ($cs -split '\n')[0]
    $EventHubsCompatibleEndpoint = $cs.Replace('"','')
    write-host $EventHubsCompatibleEndpoint
    $env:EVENT_THUBS_COMPATIBILITY_ENDPOINT = $EventHubsCompatibleEndpoint
    
    # EventHubsCompatiblePath
    write-host 'Getting EventHubsCompatiblePath'
    $cs = az iot hub show --query properties.eventHubEndpoints.events.path --name $HubName --output json  |out-string
    $cs = ($cs -split '\n')[0]
    $EventHubsCompatiblePath = $cs.Replace('"','')
    write-host $EventHubsCompatiblePath 
    $env:EVENT_HUBS_COMPATIBILITY_PATH =$EventHubsCompatiblePath


    
    # EventHubsSasKey
    write-host 'Getting EventHubsSasKey'
    $cs = az iot hub policy show --name iothubowner --query primaryKey --hub-name $HubName   |out-string
    $cs = ($cs -split '\n')[0]
    $EventHubsSasKey = $cs.Replace('"','')
    write-host  $EventHubsSasKey
    $envEVENT_HUBS_SAS_KEY=$EventHubsSasKey

    # EventHubsConnectionString
    write-host 'Calculating the Builtin Event Hub-Compatible Endpoint Connection String'
    # Endpoint=sb://<FQDN>/;SharedAccessKeyName=<KeyName>;SharedAccessKey=<KeyValue>
    $cs = "Endpoint=sb://iothub-ns-qwerty-2862278-31b54ca8c2.servicebus.windows.net/;SharedAccessKeyName=iothubowner;SharedAccessKey=kVFKa00TrE6ExALK1CRSviyppoioTXhp4A2O3j5jd4Q=;EntityPath=qwerty"
    $EventHubsConnectionString = $cs
    write-host $EventHubsConnectionString
    $env:EVENT_HUBS_CONNECTION_STRING = $EventHubsConnectionString
}
