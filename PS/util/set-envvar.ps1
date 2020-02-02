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
    $cs = az iot hub show-connection-string --name $HubName --policy-name $SharedAccesKeyName --key primary  --resource-group $GroupName --output json  
    $IOTHUB_CONN_STRING_CSHARP = ($cs   | ConvertFrom-Json).connectionString
    write-host $IOTHUB_CONN_STRING_CSHARP
    $env:IOTHUB_CONN_STRING_CSHARP =$IOTHUB_CONN_STRING_CSHARP 

    return
    
    ////////////////////////////////////////
    
    # Service Connection string
     write-host 'Getting Service Connection string'
     $SERVICE_CONNECTION_STRING = az iot hub show-connection-string --policy-name service --name $HubName --output table | out-string
     write-host $SERVICE_CONNECTION_STRING
     $env:SERVICE_CONNECTION_STRING = $SERVICE_CONNECTION_STRING

    $REMOTE_HOST_NAME = ""
    $env:REMOTE_HOST_NAME = $REMOTE_HOST_NAME

    $REMOTE_PORT  =""
    $env:REMOTE_PORT = $REMOTE_PORT
    
    # Service Connection string
    write-host 'Getting Service Connection string'
    $SERVICE_CONNECTION_STRING = az iot hub show-connection-string --policy-name service --name $HubName --output table | out-string
    write-host $SERVICE_CONNECTION_STRING
    $env:SERVICE_CONNECTION_STRING = $SERVICE_CONNECTION_STRING

    write-host 'Getting IOTHUB_CONN_STRING_CSHARP'
    $IOTHUB_CONN_STRING_CSHARP = az iot hub show-connection-string --name $HubName --policy-name service --key primary  --resource-group $GroupName --output table | out-string
    write-host $IOTHUB_CONN_STRING_CSHARP
    $env:IOTHUB_CONN_STRING_CSHARP =$IOTHUB_CONN_STRING_CSHARP

    $DEVICE_ID = $DeviceName
    $env:DEVICE_ID = $DEVICE_ID 

    $EventHubsConnectionString = ""
    $env:EventHubsConnectionString = $EventHubsConnectionString

    $EventHubsCompatibleEndpoint = az iot hub show --query properties.eventHubEndpoints.events.endpoint --name $HubName |out-string
    $env:EventHubsCompatibleEndpoint = $EventHubsCompatibleEndpoint.Replace('"','')
    
    $EventHubsCompatiblePath= az iot hub show --query properties.eventHubEndpoints.events.path --name $HubName  |out-string
    $env:EventHubsCompatiblePath =$EventHubsCompatiblePath

    $EventHubPrimaryKeyCode = az iot hub policy show --name  $HubKeyNamequery primaryKey --hub-name $HubName  |out-string

    
    $EventHubsSasKey =""
    $env:EventHubsSasKey=$EventHubsSasKey
}