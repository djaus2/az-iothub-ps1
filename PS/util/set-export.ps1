function trimm{
    param (
    [string]$line='' 
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

function clear-export{
    unset IOTHUB_DEVICE_CONN_STRING 
    unset IOTHUB_CONN_STRING_CSHARP 
    unset REMOTE_HOST_NAME 
    unset REMOTE_PORT 
    unset DEVICE_NAME
    unset DEVICE_ID 
    unset SHARED_ACCESS_KEY_NAME 
    unset EVENT_HUBS_COMPATIBILITY_PATH  
    unset EVENT_HUBS_CONNECTION_STRING 
    unset EVENT_HUBS_SAS_KEY 
    unset EVENT_HUBS_COMPATIBILITY_ENDPOINT  
    unset SERVICE_CONNECTION_STRING 
}

function set-export{
    param (
    [string]$Subscription='' ,
    [string]$GroupName='' ,
    [string]$HubName='' ,
    [string]$DeviceName=''
    )

    util\heading '  S E T   E X P O R T  V A R S   '  -BG DarkGreen   -FG White

    write-Host ''
    write-Host Note: Environment Variables only exist for the life of the current Shell -BackGroundColor DarkRed -ForeGroundColor White
        write-Host ''
    #SharedAccesKeyName
    $SharedAccesKeyName='iothubowner'
     write-Host 'Getting IOTHUB_DEVICE_CONN_STRING'
    $cs = az iot hub device-identity show-connection-string --hub-name $HubName --device-id $DeviceName  --output json  | out-string
    $IOTHUB_DEVICE_CONN_STRING = ($cs   | ConvertFrom-Json).connectionString
    write-Host $IOTHUB_DEVICE_CONN_STRING
    export IOTHUB_DEVICE_CONN_STRING = $IOTHUB_DEVICE_CONN_STRING 


    # Hub Coonection String
    #                             az iot hub show-connection-string --name $HubName --policy-name iothubowner --key primary  --resource-group $GroupName --output table
    write-host 'Getting IOTHUB_CONN_STRING_CSHARP'
    $cs = az iot hub show-connection-string --name $HubName --policy-name iothubowner --key primary  --resource-group $GroupName --output json  
    $IOTHUB_CONN_STRING_CSHARP = ($cs   | ConvertFrom-Json).connectionString
    write-host $IOTHUB_CONN_STRING_CSHARP
    export IOTHUB_CONN_STRING_CSHARP =$IOTHUB_CONN_STRING_CSHARP 

    
    
    # Service Connection string
     write-host 'Getting Service Connection string'
      $cs = az iot hub show-connection-string --policy-name service --name $HubName --output json | out-string
      $SERVICE_CONNECTION_STRING = ($cs   | ConvertFrom-Json).connectionString
      write-host $SERVICE_CONNECTION_STRING
     export SERVICE_CONNECTION_STRING = $SERVICE_CONNECTION_STRING

    #DeviceID
    write-host 'DEVICE_ID'
    $DEVICE_ID = $DeviceName
    write-Host $DEVICE_ID
    export DEVICE_ID = $DEVICE_ID 



    # EventHubsCompatibleEndpoint
    write-host 'Getting EventHubsCompatibleEndpoint'
    $cs =  az iot hub show --query properties.eventHubEndpoints.events.endpoint --name $HubName --output json |out-string
    $cs = trimm($cs)
    $EventHubsCompatibleEndpoint = $cs.Replace('"','')
    write-host $EventHubsCompatibleEndpoint
    export EVENT_THUBS_COMPATIBILITY_ENDPOINT = $EventHubsCompatibleEndpoint
    
    # EventHubsCompatiblePath
    write-host 'Getting EventHubsCompatiblePath'
    $cs = az iot hub show --query properties.eventHubEndpoints.events.path --name $HubName --output json  |out-string
    $cs = trimm $cs
    $EventHubsCompatiblePath = $cs
    write-host $EventHubsCompatiblePath 
    export EVENT_HUBS_COMPATIBILITY_PATH =$EventHubsCompatiblePath


    
    # EventHubsSasKey
    write-host 'Getting EventHubsSasKey'
    $cs = az iot hub policy show --name iothubowner --query primaryKey --hub-name $HubName   |out-string
    $cs = trimm $cs
    $EventHubsSasKey = $cs
    write-host  $EventHubsSasKey
    export EVENT_HUBS_SAS_KEY=$EventHubsSasKey

    # EventHubsConnectionString
    write-host 'Calculating the Builtin Event Hub-Compatible Endpoint Connection String'
    # Endpoint=sb://<FQDN>/;SharedAccessKeyName=<KeyName>;SharedAccessKey=<KeyValue>
    $cs = "Endpoint=sb://iothub-ns-qwerty-2862278-31b54ca8c2.servicebus.windows.net/;SharedAccessKeyName=iothubowner;SharedAccessKey=kVFKa00TrE6ExALK1CRSviyppoioTXhp4A2O3j5jd4Q=;EntityPath=qwerty"
    $cs = trimm $cs
    $EventHubsConnectionString = $cs
    write-host $EventHubsConnectionString
    export EVENT_HUBS_CONNECTION_STRING = $EventHubsConnectionString

    # The next two are only required by Device Streaming Proxy Hub

    # Remote Host Name
    write-host ''
    write-host 'Next two are only required by Device Streaming SSH/RDP Proxy Quickstart.'
    write-host " See https://docs.microsoft.com/en-us/azure/iot-hub/quickstart-device-streams-proxy-csharp"
    write-host 'REMOTE_HOST_NAME'
    $REMOTE_HOST_NAME = "localhost"
    write-host $REMOTE_HOST_NAME
    export REMOTE_HOST_NAME = $REMOTE_HOST_NAME

    # Remote Port
    write-host 'REMOTE_PORT'
    $REMOTE_PORT  =  2222
    write-host $REMOTE_PORT 
    export REMOTE_PORT = $REMOTE_PORT
    get-anykey
}

function write-export{
    param (
    [string]$Subscription='' ,
    [string]$GroupName='' ,
    [string]$HubName='' ,
    [string]$DeviceName='',
    [string]$folder =''
    )

    
    util\heading '  W R I T E   E X P O R T S  E N V I R O N M E N T  V A R S  T O  F I L E  '  -BG DarkGreen   -FG White

    show-quickstarts 'Location to save set-env.sh to.' 'Quickstarts,ScriptHostRoot'
    $foldername =  $global:retVal1

    util\heading '  W R I T E   E X P O R T S  E N V I R O N M E N T  V A R S  T O  F I L E  '  -BG DarkGreen   -FG White

    $answer = $global:retVal
    if ($answer -eq 'Back')
    {
        return $answer
    }


    

    $PsScriptFile = "$answer\set-env.sh"
    if ($answer -eq 'Quickstarts'){
        $PsScriptFile = "$global:ScriptDirectory\Quickstarts\set-env.sh"
    }
    elseif ($answer -eq 'ScriptHostRoot'){
        $PsScriptFile = "$global:ScriptDirectory\set-env.sh"
    }

    write-host 'Writing to:'
    read-host $PsScriptFile    
    $op='#!/bin/bash'
    Out-File -FilePath $PsScriptFile     -InputObject $op -Encoding ASCII

    $prompt =  'Do you want to include DOT references in env settings??'
    write-Host $prompt
    get-yesorno $true
    $response = $global:retVal

    if ($response)
    {


        $prompt = "# This script meant to run in the specific Quickstart folder: $foldername."
        $op='$dnp = "../../dotnet"'
        switch ($global:retVal2)
        {
            8 {
                $prompt = "# This script meant to run in PS."
                $op='$dnp ="$global:ScriptDirectory/quickstarts/dotnet"'
            }
            7 {
                $prompt = "# This script is meant to run in Quickstarts."
                $op='$dnp ="$global:ScriptDirectory/dotnet"'
            }
        }
        #Add-Content -Path $PsScriptFile     -Value $prompt 
        #$opdir='$global:ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent'
        # Add-Content -Path $PsScriptFile     -Value $opdir
        # Add-Content -Path $PsScriptFile     -Value $op 
        
  
 
        switch ($global:retVal2)
        {
            8 {
                $prompt = "# This script meant to run in PS."
                Add-Content -Path $PsScriptFile     -Value $prompt
                $op='export DOTNET_ROOT=$PWD/Quickstarts//dotnet'
                Add-Content -Path $PsScriptFile     -Value $op 
                $op='export PATH=$PATH:$PWD/Qickstarts/dotnet' 
                Add-Content -Path $PsScriptFile     -Value $op
            }
            7 {
                $prompt = "# This script is meant to run in Quickstarts."
                Add-Content -Path $PsScriptFile     -Value $prompt 
                $op='export DOTNET_ROOT=$PWD/dotnet'
                Add-Content -Path $PsScriptFile     -Value $op 
                $op='export PATH=$PATH:$PWD/dotnet' 
                Add-Content -Path $PsScriptFile     -Value $op
            }
            deault {
                $prompt = "# This script meant to run in the specific Quickstart folder: $foldername."
                Add-Content -Path $PsScriptFile     -Value $prompt
                # To do here got ot get ..\..\dotnet
            }
        } 
    }
    

    #SharedAccesKeyName
    $SharedAccesKeyName='iothubowner'
    # $SharedAccesKeyName='service'
    write-Host "1. SHARED_ACCESS_KEY_NAME = $SharedAccesKeyName" 
    $op = "export SHARED_ACCESS_KEY_NAME='$SharedAccesKeyName'"
    Add-Content -Path $PsScriptFile     -Value $op
    
    If (-not ([string]::IsNullOrEmpty($DeviceName )))    
    {   
        write-Host "2. DEVICE_NAME = $DeviceName"
        $op = "export DEVICE_NAME='$DeviceName'"
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
    write-Host "3. IOTHUB_DEVICE_CONN_STRING = $IOTHUB_DEVICE_CONN_STRING"
    $op = "export IOTHUB_DEVICE_CONN_STRING='$IOTHUB_DEVICE_CONN_STRING'"
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
    $op = "export IOTHUB_CONN_STRING_CSHARP='$IOTHUB_CONN_STRING_CSHARP'"
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
    write-host "5. SERVICE_CONNECTION_STRING = $SERVICE_CONNECTION_STRING"
    $op = "export SERVICE_CONNECTION_STRING='$SERVICE_CONNECTION_STRING'"
    Add-Content -Path  $PsScriptFile  -Value $op

    #DeviceID
    $DEVICE_ID = $DeviceName
    write-Host "6. DEVICE_ID = $DEVICE_ID"
    $op = "export DEVICE_ID='$DEVICE_ID'"
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
    write-host "7. EVENT_HUBS_COMPATIBILITY_ENDPOINT =  $EventHubsCompatibleEndpoint"
    $op = "export EVENT_THUBS_COMPATIBILITY_ENDPOINT='$EventHubsCompatibleEndpoint'"
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
    write-host "8. EVENT_HUBS_COMPATIBILITY_PATH = $EventHubsCompatiblePath"
    $op = "export EVENT_HUBS_COMPATIBILITY_PATH='$EventHubsCompatiblePath'"
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
    write-host  "9. EVENT_HUBS_SAS_KEY  = $EventHubsSasKey"
    $op = "export EVENT_HUBS_SAS_KEY='$EventHubsSasKey'"
    Add-Content -Path  $PsScriptFile  -Value $op

    # EventHubsConnectionString
    write-host 'Calculating the Builtin Event Hub-Compatible Endpoint Connection String'
    # Endpoint=sb://<FQDN>/;SharedAccessKeyName=<KeyName>;SharedAccessKey=<KeyValue>
    $cs = "Endpoint=sb://iothub-ns-qwerty-2862278-31b54ca8c2.servicebus.windows.net/;SharedAccessKeyName=iothubowner;SharedAccessKey=kVFKa00TrE6ExALK1CRSviyppoioTXhp4A2O3j5jd4Q=;EntityPath=qwerty"
    $EventHubsConnectionString = $cs
    write-host "10. EVENT_HUBS_CONNECTION_STRING =$EventHubsConnectionString"
    $op="export EVENT_HUBS_CONNECTION_STRING='$EventHubsConnectionString'"
    Add-Content -Path  $PsScriptFile  -Value $op

    # The next two are only required by Device Streaming Proxy Hub


    $REMOTE_HOST_NAME = "localhost"
    write-host "11. REMOTE_HOST_NAME =  $REMOTE_HOST_NAME"
    $op = "export REMOTE_HOST_NAME='$REMOTE_HOST_NAME'"
    Add-Content -Path  $PsScriptFile  -Value $op

    # Remote Port
    $REMOTE_PORT  =  2222
    write-host "12. REMOTE_PORT = $REMOTE_PORT"
    $op =  "export REMOTE_PORT='$REMOTE_PORT'"
    Add-Content -Path  $PsScriptFile  -Value $op

    write-Host "Written PowerShell script to:  $PsScriptFile that will set the Hub connection strings as Env. Vars"
    get-anykey

}









