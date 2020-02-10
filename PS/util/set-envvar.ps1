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
    $env:IOTHUB_CONN_STRING_CSHARP = $null
    $env:REMOTE_HOST_NAME = $null
    $env:REMOTE_PORT = $null
    $env:DEVICE_NAME = $nul
    $env:DEVICE_ID = $null
    $env:SHARED_ACCESS_KEY_NAME =$null
    $env:EVENT_HUBS_COMPATIBILITY_PATH  = $null
    $env:EVENT_HUBS_CONNECTION_STRING = $null
    $env:EVENT_HUBS_SAS_KEY = $null
    $env:EVENT_HUBS_COMPATIBILITY_ENDPOINT  =$null
    $env:SERVICE_CONNECTION_STRING = $null
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

    show-quickstarts 'Location to save Envs' 'Quickstarts,ScriptHostRoot'

    $answer = $global:retVal
    if ($answer -eq 'Back')
    {
        return $answer
    }
    

    $PsScriptFile = "$answer\set-env.ps1"
    if ($answer -eq 'Quickstarts'){
        $PsScriptFile = "$global:ScriptDirectory\Quickstarts\set-env.ps1"
    }
    elseif ($answer -eq 'ScriptHostRoot'){
        $PsScriptFile = "$global:ScriptDirectory\set-env.ps1"
    }

    write-host 'Writing to:'
    read-host $PsScriptFile
    Out-File -FilePath $PsScriptFile    -InputObject "" -Encoding ASCII


    #SharedAccesKeyName
    $SharedAccesKeyName = 'iothubowner'
    # $SharedAccesKeyName = 'service'
    write-Host "1. SHARED_ACCESS_KEY_NAME = $SharedAccesKeyName" 
    $op = '$env:SHARED_ACCESS_KEY_NAME = "' + $SharedAccesKeyName +'"'
    Add-Content -Path $PsScriptFile     -Value $op 


    If (-not ([string]::IsNullOrEmpty($DeviceName )))
    {   
        write-Host "2. DEVICE_NAME = $DeviceName"
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
        $IOTHUB_DEVICE_CONN_STRING=$env:IOTHUB_DEVICE_CONN_STRING
    }
    write-Host "3. IOTHUB_DEVICE_CONN_STRING = $IOTHUB_DEVICE_CONN_STRING"
    $op = '$env:IOTHUB_DEVICE_CONN_STRING = "' + $IOTHUB_DEVICE_CONN_STRING +'"'
    Add-Content -Path $PsScriptFile     -Value $op
 


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
    write-host "5. SERVICE_CONNECTION_STRING = $SERVICE_CONNECTION_STRING"
    $op = '$env:SERVICE_CONNECTION_STRING = "' + $SERVICE_CONNECTION_STRING +'"'
    Add-Content -Path  $PsScriptFile -Value $op

    #DeviceID
    $DEVICE_ID = $DeviceName
    write-Host "6. DEVICE_ID = $DEVICE_ID"
    $op = '$env:DEVICE_ID = "' + $DEVICE_ID +'"'
    Add-Content -Path  $PsScriptFile  -Value $op



    # EventHubsCompatibleEndpoint
    If ([string]::IsNullOrEmpty($env:EVENT_HUBS_COMPATIBILITY_ENDPOINT ))
    {  
    write-host 'Getting EventHubsCompatibleEndpoint'
    $cs =  az iot hub show --query properties.eventHubEndpoints.events.endpoint --name $HubName --output json |out-string
    $cs = trimm $cs
    $EventHubsCompatibleEndpoint = $cs
    }else{
        $EventHubsCompatibleEndpoint =   $env:EventHubsCompatibleEndpoint 
    }
    write-host "7. EVENT_HUBS_COMPATIBILITY_ENDPOINT =  $EventHubsCompatibleEndpoint"
    $op = '$env:EVENT_HUBS_COMPATIBILITY_ENDPOINT = "' + $EventHubsCompatibleEndpoint +'"'
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
    write-host "8. EventHubsCompatiblePath = $EventHubsCompatiblePath"
    $op = '$env:EVENT_HUBS_COMPATIBILITY_PATH = "' + $EventHubsCompatiblePath +'"'
    Add-Content -Path  $PsScriptFile  -Value $op


    
    # EventHubsSasKey
    If ([string]::IsNullOrEmpty($env:EVENT_HUBS_SAS_KEY ))
    {  
        write-host 'Getting EventHubsSasKey'
        $cs = az iot hub policy show --name iothubowner --query primaryKey --hub-name $HubName   |out-string
        $cs = trimm $cs
        $EventHubsSasKey = $cs
    } else {
        $EventHubsSasKey = $env:EVENT_HUBS_SAS_KEY 
    }
    write-host  "9. EVENT_HUBS_SAS_KEY  = $EventHubsSasKey"
    $op = '$env:EVENT_HUBS_SAS_KEY = "' + $EventHubsSasKey +'"'
    Add-Content -Path  $PsScriptFile  -Value $op


    # EventHubsConnectionString
    write-host 'Calculating the Builtin Event Hub-Compatible Endpoint Connection String'
    # Endpoint=sb://<FQDN>/;SharedAccessKeyName=<KeyName>;SharedAccessKey=<KeyValue>
    $cs = "Endpoint=sb://iothub-ns-qwerty-2862278-31b54ca8c2.servicebus.windows.net/;SharedAccessKeyName=iothubowner;SharedAccessKey=kVFKa00TrE6ExALK1CRSviyppoioTXhp4A2O3j5jd4Q=;EntityPath=qwerty"
    $EventHubsConnectionString = $cs
    write-host "10. EVENT_HUBS_CONNECTION_STRING = $EventHubsConnectionString"
    $op = '$env:EVENT_HUBS_CONNECTION_STRING = "' + $EventHubsConnectionString +'"'
    Add-Content -Path  $PsScriptFile  -Value $op

    # The next two are only required by Device Streaming Proxy Hub

    # Remote Host Name
    #write-host ''
    #write-host 'Next two are only required by Device Streaming SSH/RDP Proxy Quickstart.'
    #write-host " See https://docs.microsoft.com/en-us/azure/iot-hub/quickstart-device-streams-proxy-csharp"
    #write-host 'REMOTE_HOST_NAME'
    $REMOTE_HOST_NAME =  "localhost"
    write-host "11. REMOTE_HOST_NAME =  $REMOTE_HOST_NAME"
    $op = '$env:REMOTE_HOST_NAME = "' + $REMOTE_HOST_NAME +'"'
    Add-Content -Path  $PsScriptFile  -Value $op
    # Remote Port
    # write-host 'REMOTE_PORT'
    $REMOTE_PORT  =  2222
    write-host "12. REMOTE_PORT = $REMOTE_PORT"
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

function read-env{
    param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$DeviceName = '',
    [string]$folder =''
    )

    show-quickstarts 'Location of Envs file' 'Quickstarts,ScriptHostRoot'

    $answer = $global:retVal
    if ($answer -eq 'Back')
    {
        return $answer
    }
    

    
    $PsScriptFile = "$answer\set-env.ps1"
    if ($answer -eq 'Quickstarts'){
        $PsScriptFile = "$global:ScriptDirectory\Quickstarts\set-env.ps1"
    }
    elseif ($answer -eq 'ScriptHostRoot'){
        $PsScriptFile = "$global:ScriptDirectory\set-env.ps1"
    }

    write-host 'Reading from: '
    read-host $PsScriptFile

    Try {
        If (Test-Path $PsScriptFile) {
            & $PsScriptFile
        }
        else {
            write-Host "File $PsScriptFile not found. "
        }
    } catch {
        Write-Host "Error tring to run set-env script." 
        Write-Host $_
    }


 }

 function show-env{
    param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$DeviceName = '',
    [string]$folder =''
    )
    #SharedAccesKeyName
    If  (-not([string]::IsNullOrEmpty($env:SHARED_ACCESS_KEY_NAME )))
    {   
        write-Host "1. SHARED_ACCESS_KEY_NAME = $env:SHARED_ACCESS_KEY_NAME" 
    }


    If (-not([string]::IsNullOrEmpty($env:DEVICE_NAME )))
    {   
        write-Host "2. DEVICE_NAME = $env:DEVICE_NAME"
    }

    # Device Connection String
    #                             az iot hub device-identity show-connection-string --hub-name {YourIoTHubName} --device-id MyDevice --output table
    #                             az iot hub device-identity show-connection-string --hub-name $HubName --device-id $DeviceName --output table
    If (-not([string]::IsNullOrEmpty($env:IOTHUB_DEVICE_CONN_STRING )))
    {  
        write-Host "3. IOTHUB_DEVICE_CONN_STRING = $env:IOTHUB_DEVICE_CONN_STRING"
    }
 

    # Hub Coonection String
    #                             az iot hub show-connection-string --name $HubName --policy-name iothubowner --key primary  --resource-group $GroupName --output table
    If(-not ([string]::IsNullOrEmpty($env:IOTHUB_CONN_STRING_CSHARP )))
    {  
        write-host "4. IOTHUB_CONN_STRING_CSHARP =  $env:IOTHUB_CONN_STRING_CSHARP"
    }
    
    
    # Service Connection string'
    If (-not([string]::IsNullOrEmpty($env:SERVICE_CONNECTION_STRING )))
    {  
        write-host "5. SERVICE_CONNECTION_STRING = $env:SERVICE_CONNECTION_STRING"
    }



    #DeviceID
    If (-not ([string]::IsNullOrEmpty($env:DEVICE_ID )))
    { 
        write-Host "6. DEVICE_ID = $env:DEVICE_ID"
    }



    # EventHubsCompatibleEndpoint
    If (-not([string]::IsNullOrEmpty($env:EVENT_HUBS_COMPATIBILITY_ENDPOINT )))
    {  
        write-host "7. EVENT_HUBS_COMPATIBILITY_ENDPOINT =  $env:EVENT_HUBS_COMPATIBILITY_ENDPOINT"
    }
    
    # EventHubsCompatiblePath
    If (-not([string]::IsNullOrEmpty($env:EVENT_HUBS_COMPATIBILITY_PATH )))
    {  
        write-host "8. EventHubsCompatiblePath = $env:EVENT_HUBS_COMPATIBILITY_PATH"
    }
    
    # EventHubsSasKey
    If (-not ([string]::IsNullOrEmpty($env:EVENT_HUBS_SAS_KEY )))
    {  
        write-host  "9. EVENT_HUBS_SAS_KEY  = $env:EVENT_HUBS_SAS_KEY"
    }

    If (-not ([string]::IsNullOrEmpty($env:EVENT_HUBS_CONNECTION_STRING )))
    { 
        write-host "10. EVENT_HUBS_CONNECTION_STRING = $env:EVENT_HUBS_CONNECTION_STRING"
    }

    # The next two are only required by Device Streaming Proxy Hub

    # Remote Host Name
    If (-not ([string]::IsNullOrEmpty($env:REMOTE_HOST_NAME )))
    { 
        write-host "11. REMOTE_HOST_NAME =  $env:REMOTE_HOST_NAME"
    }

    # Remote Port
    If (-not ([string]::IsNullOrEmpty($env:REMOTE_HOST_NAME )))
    { 
        write-host "12. REMOTE_PORT = $env:REMOTE_PORT"
    }

    get-anykey

    
}










