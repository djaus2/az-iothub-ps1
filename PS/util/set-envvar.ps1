
    try {
        . ("$global:ScriptDirectory\util\save-appdata.ps1")
    }
    catch {
        Write-Host "Error while loading supporting PowerShell Scripts" 
        Write-Host $_
    }

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



    
    If  (-not([string]::IsNullOrEmpty($env:SHARED_ACCESS_KEY_NAME )))
    {   
        REG delete HKCU\Environment /F /V   SHARED_ACCESS_KEY_NAME 
    }


    If (-not([string]::IsNullOrEmpty($env:DEVICE_NAME )))
    {   
        REG delete HKCU\Environment /F /V   DEVICE_NAME
    }



    # Device Connection String
    If (-not([string]::IsNullOrEmpty($env:IOTHUB_DEVICE_CONN_STRING )))
    {  
        REG delete HKCU\Environment /F /V   IOTHUB_DEVICE_CONN_STRING
    }
 

   If(-not ([string]::IsNullOrEmpty($env:IOTHUB_CONN_STRING_CSHARP )))
    {  
        REG delete HKCU\Environment /F /V   IOTHUB_CONN_STRING_CSHARP
    }

    
    
    # Service Connection string'
    If (-not([string]::IsNullOrEmpty($env:SERVICE_CONNECTION_STRING )))
    {  
        REG delete HKCU\Environment /F /V   SERVICE_CONNECTION_STRING
    }




    #DeviceID
    If (-not ([string]::IsNullOrEmpty($env:DEVICE_ID )))
    { 
        REG delete HKCU\Environment /F /V   DEVICE_ID
    }




    # EventHubsCompatibleEndpoint
    If (-not([string]::IsNullOrEmpty($env:EVENT_HUBS_COMPATIBILITY_ENDPOINT )))
    {  
        REG delete HKCU\Environment /F /V   EVENT_HUBS_COMPATIBILITY_ENDPOINT 
    }

    # EventHubsCompatiblePath
    If (-not([string]::IsNullOrEmpty($env:EVENT_HUBS_COMPATIBILITY_PATH )))
    {  
        REG delete HKCU\Environment /F /V   EventHubsCompatiblePath
    }

    
    # EventHubsSasKey
    If (-not ([string]::IsNullOrEmpty($env:EVENT_HUBS_SAS_KEY )))
    {  
        REG delete HKCU\Environment /F /V   EVENT_HUBS_SAS_KEY
    }


    If (-not ([string]::IsNullOrEmpty($env:EVENT_HUBS_CONNECTION_STRING )))
    { 
        REG delete HKCU\Environment /F /V   EVENT_HUBS_CONNECTION_STRING
    }



    # Remote Host Name
    If (-not ([string]::IsNullOrEmpty($env:REMOTE_HOST_NAME )))
    { 
        REG delete HKCU\Environment /F /V   REMOTE_HOST_NAME  -Scope Local
    }


    # Remote Port
    If (-not ([string]::IsNullOrEmpty($env:REMOTE_HOST_NAME )))
    { 
        REG delete HKCU\Environment /F /V   REMOTE_PORT  -Scope Local
    }

    $env:IOTHUB_DEVICE_CONN_STRING = $null
    $env:IOTHUB_CONN_STRING_CSHARP = $null
    $env:REMOTE_HOST_NAME = $null
    $env:REMOTE_PORT = $null
    $env:DEVICE_NAME = $null
    $env:DEVICE_ID = $null
    $env:SHARED_ACCESS_KEY_NAME = $null
    $env:EVENT_HUBS_COMPATIBILITY_PATH  = $null
    $env:EVENT_HUBS_CONNECTION_STRING = $null
    $env:EVENT_HUBS_SAS_KEY = $null
    $env:EVENT_HUBS_COMPATIBILITY_ENDPOINT  = $null
    $env:SERVICE_CONNECTION_STRING = $null



  
    If  (-not([string]::IsNullOrEmpty($SHARED_ACCESS_KEY_NAME )))
    {   
        remove-variable  SHARED_ACCESS_KEY_NAME  -Scope Local 
    }


    If (-not([string]::IsNullOrEmpty($DEVICE_NAME )))
    {   
        remove-variable  DEVICE_NAME  -Scope Local
    }



    # Device Connection String
    If (-not([string]::IsNullOrEmpty($IOTHUB_DEVICE_CONN_STRING )))
    {  
        remove-variable  IOTHUB_DEVICE_CONN_STRING   -Scope Local
    }
 

   If(-not ([string]::IsNullOrEmpty($IOTHUB_CONN_STRING_CSHARP )))
    {  
        remove-variable  IOTHUB_CONN_STRING_CSHARP  -Scope Local
    }

    
    
    # Service Connection string'
    If (-not([string]::IsNullOrEmpty($SERVICE_CONNECTION_STRING )))
    {  
        remove-variable  SERVICE_CONNECTION_STRING  -Scope Local
    }




    #DeviceID
    If (-not ([string]::IsNullOrEmpty($DEVICE_ID )))
    { 
        remove-variable  DEVICE_ID  -Scope Local
    }




    # EventHubsCompatibleEndpoint
    If (-not([string]::IsNullOrEmpty($EVENT_HUBS_COMPATIBILITY_ENDPOINT )))
    {  
        remove-variable  EVENT_HUBS_COMPATIBILITY_ENDPOINT    -Scope Local
    }

    # EventHubsCompatiblePath
    If (-not([string]::IsNullOrEmpty($EVENT_HUBS_COMPATIBILITY_PATH )))
    {  
        remove-variable  EventHubsCompatiblePath  -Scope Local
    }

    
    # EventHubsSasKey
    If (-not ([string]::IsNullOrEmpty($EVENT_HUBS_SAS_KEY )))
    {  
        remove-variable  EVENT_HUBS_SAS_KEY  -Scope Local
    }


    If (-not ([string]::IsNullOrEmpty($EVENT_HUBS_CONNECTION_STRING )))
    { 
        remove-variable  EVENT_HUBS_CONNECTION_STRING  -Scope Local
    }



    # Remote Host Name
    If (-not ([string]::IsNullOrEmpty($REMOTE_HOST_NAME )))
    { 
        remove-variable  REMOTE_HOST_NAME  -Scope Local
    }


    # Remote Port
    If (-not ([string]::IsNullOrEmpty($REMOTE_HOST_NAME )))
    { 
        remove-variable  REMOTE_PORT  -Scope Local
    }

    ########################



    If  (-not([string]::IsNullOrEmpty($global:SHARED_ACCESS_KEY_NAME )))
    {   
        remove-variable  SHARED_ACCESS_KEY_NAME  -Scope Global 
    }


    If (-not([string]::IsNullOrEmpty($global:DEVICE_NAME )))
    {   
        remove-variable  DEVICE_NAME  -Scope global
    }



    # Device Connection String
    If (-not([string]::IsNullOrEmpty($global:IOTHUB_DEVICE_CONN_STRING )))
    {  
        remove-variable  IOTHUB_DEVICE_CONN_STRING   -Scope global
    }
 

   If(-not ([string]::IsNullOrEmpty($global:IOTHUB_CONN_STRING_CSHARP )))
    {  
        remove-variable  IOTHUB_CONN_STRING_CSHARP  -Scope global
    }

    
    
    # Service Connection string'
    If (-not([string]::IsNullOrEmpty($global:SERVICE_CONNECTION_STRING )))
    {  
        remove-variable  SERVICE_CONNECTION_STRING  -Scope global
    }




    #DeviceID
    If (-not ([string]::IsNullOrEmpty($global:DEVICE_ID )))
    { 
        remove-variable  DEVICE_ID  -Scope global
    }




    # EventHubsCompatibleEndpoint
    If (-not([string]::IsNullOrEmpty($global:EVENT_HUBS_COMPATIBILITY_ENDPOINT )))
    {  
        remove-variable  EVENT_HUBS_COMPATIBILITY_ENDPOINT    -Scope global
    }

    # EventHubsCompatiblePath
    If (-not([string]::IsNullOrEmpty($global:EVENT_HUBS_COMPATIBILITY_PATH )))
    {  
        remove-variable  EventHubsCompatiblePath  -Scope global
    }

    
    # EventHubsSasKey
    If (-not ([string]::IsNullOrEmpty($global:EVENT_HUBS_SAS_KEY )))
    {  
        remove-variable  EVENT_HUBS_SAS_KEY  -Scope global
    }


    If (-not ([string]::IsNullOrEmpty($global:EVENT_HUBS_CONNECTION_STRING )))
    { 
        remove-variable  EVENT_HUBS_CONNECTION_STRING  -Scope global
    }



    # Remote Host Name
    If (-not ([string]::IsNullOrEmpty($env:REMOTE_HOST_NAME )))
    { 
        remove-variable  REMOTE_HOST_NAME  -Scope Local
    }


    # Remote Port
    If (-not ([string]::IsNullOrEmpty($env:REMOTE_HOST_NAME )))
    { 
        remove-variable  REMOTE_PORT  -Scope Local
    }

    #########################

    
    
    $PsScriptFile =  "$global:ScriptDirectory\set-env.ps1"
    Remove-Item  $PsScriptFile 

    $PsScriptFile =  "$global:ScriptDirectory\set-env.sh"
    Remove-Item  $PsScriptFile 
    
    clear-appData

    get-anykey 'Done'

}

function Get-All{
    param (
        [string]$Subscription = '' ,
        [string]$GroupName = '' ,
        [string]$HubName = '' ,
        [string]$DeviceName = ''
        )

        write-host "[4] Get connection strings."
        set-env  $Subscription $GroupName $HubName $DeviceName
        show-env  $Subscription $GroupName $HubName $DeviceNam
        write-host [4.1] Write to PS script in Quickstarts folder
        write-env  $Subscription $GroupName $HubName $DeviceNam 'quickstarts'
        write-host [4.2] Write to Bash script in Quickstarts folder
        write-export  $Subscription $grp $hb $dev 'quickstarts'
}

function set-env{
    param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$DeviceName = ''
    )



    show-heading '  S E T   E N V I R O N M E N T  V A R S   '  3

    write-Host ''
    write-Host Note: Environment Variables only exist for the life of the current Shell -BackGroundColor DarkRed -ForeGroundColor White
    write-Host 'Use 3. Permanently Set Env Vars, on previous menu to lock them in'
    write-Host ''

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

    write-Host 'Done'
    get-anykey
}

function write-env{
    param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$DeviceName = '',
    [string]$foldername =''
    )

    show-heading '  W R I T E   E N V I R O N M E N T  V A R S  T O  P S  F I L E  '  3

    $answer = $foldername
    If  ([string]::IsNullOrEmpty($foldername))
    {
        show-quickstarts 'Location to save set-env.ps1 to.' 'Quickstarts,ScriptHostRoot'
        $foldername =  $global:retVal1
        $answer = $global:retVal

        show-heading '  W R I T E   E N V I R O N M E N T  V A R S  T O  P S   F I L E  '  3
    }

    
    if ($answer -eq 'Back')
    {
        return $answer
    }
    

    $PsScriptFile = "$foldername\set-env.ps1"
    if ($answer.ToLower() -eq 'quickstarts'){
        $PsScriptFile = "$global:ScriptDirectory\qs-apps\quickstarts\set-env.ps1"
    }
    elseif ($answer.ToLower() -eq 'scriptHostRoot'){
        $PsScriptFile = "$global:ScriptDirectory\set-env.ps1"
    }

    write-host "Writing Env Vars to: $PsScriptFile"
    get-anykey $prompt, 'Continue'

    Out-File -FilePath $PsScriptFile    -InputObject "" -Encoding ASCII


    $prompt =  'Do you want to include DOT references in env settings??'
    write-Host $prompt
    get-yesorno $true
    $response = $global:retVal

    if ($response)
    {


        $prompt = "# This script meant to run in the specific Quickstart folder: $foldername."
        $op = '$dnp = "..\dotnet"'
        switch ($global:retVal2)
        {
            8 {
                $prompt = "# This script meant to run in PS."
                $op = '$dnp ="$global:ScriptDirectory\qs-apps\quickstarts\dotnet"'
            }
            7 {
                $prompt = "# This script is meant to run in Quickstarts."
                $op = '$dnp ="$global:ScriptDirectory\dotnet"'
            }
        }
        Add-Content -Path $PsScriptFile     -Value $prompt 
        $opdir='$global:ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent'
        Add-Content -Path $PsScriptFile     -Value $opdir
        Add-Content -Path $PsScriptFile     -Value $op 
        
        $op = 'if (Test-Path $dnp){'
        Add-Content -Path $PsScriptFile     -Value $op 
            $op = '     $regexAddPath = [regex]::Escape($dnp)'
            Add-Content -Path $PsScriptFile     -Value $op 
            $op = '     $arrPath = $env:Path -split ";" | Where-Object {$_ -notMatch "^$regexAddPath\\?"}'
            Add-Content -Path $PsScriptFile     -Value $op 
            $op = '     $env:Path = ($arrPath + $dnp) -join ";" '
            Add-Content -Path $PsScriptFile     -Value $op 
            $op = '     $env:DOTNET_ROOT = $dnp' 
            Add-Content -Path $PsScriptFile     -Value $op 
            
        $op = '} else {'
        Add-Content -Path $PsScriptFile     -Value $op 
        $op = '    Throw "$dnp is not a valid path."'
        Add-Content -Path $PsScriptFile     -Value $op 
        $op ='}'
        Add-Content -Path $PsScriptFile     -Value $op 
    }


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
    }else{
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
    If ([string]::IsNullOrEmpty($env:SERVICE_CONNECTION_STRING ))
    {  
        write-host 'Getting Service Connection string'
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
        $EventHubsCompatibleEndpoint =   $env:EVENT_HUBS_COMPATIBILITY_ENDPOINT
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
    $REMOTE_HOST_NAME =  "localhost"
    write-host "11. REMOTE_HOST_NAME =  $REMOTE_HOST_NAME"
    $op = '$env:REMOTE_HOST_NAME = "' + $REMOTE_HOST_NAME +'"'
    Add-Content -Path  $PsScriptFile  -Value $op
    # Remote Port
    $REMOTE_PORT  =  2222
    write-host "12. REMOTE_PORT = $REMOTE_PORT"
    $op =  '$env:REMOTE_PORT = ' + $REMOTE_PORT
    Add-Content -Path  $PsScriptFile -Value $op

    write-Host "Written PowerShell script to:  $PsScriptFile that will set the Hub connection strings as Env. Vars"
    get-anykey

}

function read-env{
    param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$DeviceName = '',
    [string]$folder =''
    )

    show-heading '  R E A D   E N V I R O N M E N T  V A R S  F R O M  F I L E '  3

    show-quickstarts 'Location of set-env.ps1 file.' 'Quickstarts,ScriptHostRoot'

    show-heading '  R E A D   E N V I R O N M E N T  V A R S  F R O M  F I L E '  3

    $answer = $global:retVal
    if ($answer -eq 'Back')
    {
        return $answer
    }
    

    
    $PsScriptFile = "$answer\set-env.ps1"
    if ($answer -eq 'Quickstarts'){
        $PsScriptFile = "$global:ScriptDirectory\qs-apps\quickstarts\set-env.ps1"
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
    write-Host 'Done'
    get-anykey

 }

 function show-env{
    param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$DeviceName = '',
    [string]$folder =''
    )
    show-heading '  S H O W   E N V I R O N M E N T  V A R S   ' 3
    
    write-Host Note: Environment Variables only exist for the life of the current Shell -BackGroundColor DarkRed -ForeGroundColor White
    write-Host ''
    #SharedAccesKeyName
    If  (-not([string]::IsNullOrEmpty($env:SHARED_ACCESS_KEY_NAME )))
    {   
        write-Host "1. SHARED_ACCESS_KEY_NAME = $env:SHARED_ACCESS_KEY_NAME" 
    }
    else
    {
        write-Host 'No $env:SHARED_ACCESS_KEY_NAME' -ForeGroundColor DarkRed
    }


    If (-not([string]::IsNullOrEmpty($env:DEVICE_NAME )))
    {   
        write-Host "2. DEVICE_NAME = $env:DEVICE_NAME"
    }
    else
    {   
        write-Host 'No $env:DEVICE_NAME'  -ForeGroundColor DarkRed
    }


    # Device Connection String
    If (-not([string]::IsNullOrEmpty($env:IOTHUB_DEVICE_CONN_STRING )))
    {  
        write-Host "3. IOTHUB_DEVICE_CONN_STRING = $env:IOTHUB_DEVICE_CONN_STRING"
    }
    else
    {  
        write-Host 'No $env:IOTHUB_DEVICE_CONN_STRING'  -ForeGroundColor DarkRed
    }
 

    # Hub Coonection String
    #                             az iot hub show-connection-string --name $HubName --policy-name iothubowner --key primary  --resource-group $GroupName --output table
    If(-not ([string]::IsNullOrEmpty($env:IOTHUB_CONN_STRING_CSHARP )))
    {  
        write-host "4. IOTHUB_CONN_STRING_CSHARP =  $env:IOTHUB_CONN_STRING_CSHARP"
    }
   else
    {  
        write-host 'No $env:IOTHUB_CONN_STRING_CSHARP'  -ForeGroundColor DarkRed
    }
    
    
    # Service Connection string'
    If (-not([string]::IsNullOrEmpty($env:SERVICE_CONNECTION_STRING )))
    {  
        write-host "5. SERVICE_CONNECTION_STRING = $env:SERVICE_CONNECTION_STRING"
    }
    else
    {  
        write-host 'No $env:SERVICE_CONNECTION_STRING'  -ForeGroundColor DarkRed
    }



    #DeviceID
    If (-not ([string]::IsNullOrEmpty($env:DEVICE_ID )))
    { 
        write-Host "6. DEVICE_ID = $env:DEVICE_ID"
    }
    else
    { 
        write-Host 'No $env:DEVICE_ID'  -ForeGroundColor DarkRed
    }



    # EventHubsCompatibleEndpoint
    If (-not([string]::IsNullOrEmpty($env:EVENT_HUBS_COMPATIBILITY_ENDPOINT )))
    {  
        write-host "7. EVENT_HUBS_COMPATIBILITY_ENDPOINT =  $env:EVENT_HUBS_COMPATIBILITY_ENDPOINT"
    }
    else
    {  
        write-host 'No $env:EVENT_HUBS_COMPATIBILITY_ENDPOINT'  -ForeGroundColor DarkRed
    }
    
    # EventHubsCompatiblePath
    If (-not([string]::IsNullOrEmpty($env:EVENT_HUBS_COMPATIBILITY_PATH )))
    {  
        write-host "8. EventHubsCompatiblePath = $env:EVENT_HUBS_COMPATIBILITY_PATH"
    }
    else
    {  
        write-host 'No $env:EventHubsCompatiblePath'  -ForeGroundColor DarkRed
    }
    
    # EventHubsSasKey
    If (-not ([string]::IsNullOrEmpty($env:EVENT_HUBS_SAS_KEY )))
    {  
        write-host  "9. EVENT_HUBS_SAS_KEY  = $env:EVENT_HUBS_SAS_KEY"
    }
    else
    {  
        write-host  'No $env:EVENT_HUBS_SAS_KEY'  -ForeGroundColor DarkRed
    }

    If (-not ([string]::IsNullOrEmpty($env:EVENT_HUBS_CONNECTION_STRING )))
    { 
        write-host "10. EVENT_HUBS_CONNECTION_STRING = $env:EVENT_HUBS_CONNECTION_STRING"
    }
    else
    { 
        write-host 'No $env:EVENT_HUBS_CONNECTION_STRING'  -ForeGroundColor DarkRed
    }

    # The next two are only required by Device Streaming Proxy Hub

    # Remote Host Name
    If (-not ([string]::IsNullOrEmpty($env:REMOTE_HOST_NAME )))
    { 
        write-host "11. REMOTE_HOST_NAME =  $env:REMOTE_HOST_NAME"
    }
    else
    { 
        write-host 'No $env:REMOTE_HOST_NAME'  -ForeGroundColor DarkRed
    }

    # Remote Port
    If (-not ([string]::IsNullOrEmpty($env:REMOTE_HOST_NAME )))
    { 
        write-host "12. REMOTE_PORT = $env:REMOTE_PORT"
    }
    else
    { 
        write-host 'No $env:REMOTE_PORT'  -ForeGroundColor DarkRed
    }
    write-Host 'Done reading Environment Variables'
    get-anykey

    
}


function set-permanent{
    param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$DeviceName = '',
    [string]$folder =''
    )
    show-heading '  S E T   E N V I R O N M E N T  V A R S  P E R M A N E N T ' 3
    
    write-Host Note: This will set the variables to User Environment Vars permanently -BackGroundColor DarkRed -ForeGroundColor White
    write-Host 'It does not regenerate the temporary values.'
    write-host ''
    #SharedAccesKeyName
    If  (-not([string]::IsNullOrEmpty($env:SHARED_ACCESS_KEY_NAME )))
    {   
        setx  SHARED_ACCESS_KEY_NAME  $env:SHARED_ACCESS_KEY_NAME 
    }



    If (-not([string]::IsNullOrEmpty($env:DEVICE_NAME )))
    {   
        setx DEVICE_NAME  $env:DEVICE_NAME
    }



    # Device Connection String
    If (-not([string]::IsNullOrEmpty($env:IOTHUB_DEVICE_CONN_STRING )))
    {  
        setx  IOTHUB_DEVICE_CONN_STRING  $env:IOTHUB_DEVICE_CONN_STRING
    }

 

   If(-not ([string]::IsNullOrEmpty($env:IOTHUB_CONN_STRING_CSHARP )))
    {  
        setx IOTHUB_CONN_STRING_CSHARP $env:IOTHUB_CONN_STRING_CSHARP
    }

    
    # Service Connection string'
    If (-not([string]::IsNullOrEmpty($env:SERVICE_CONNECTION_STRING )))
    {  
        setx SERVICE_CONNECTION_STRING $env:SERVICE_CONNECTION_STRING
    }




    #DeviceID
    If (-not ([string]::IsNullOrEmpty($env:DEVICE_ID )))
    { 
        setx  DEVICE_ID $env:DEVICE_ID
    }




    # EventHubsCompatibleEndpoint
    If (-not([string]::IsNullOrEmpty($env:EVENT_HUBS_COMPATIBILITY_ENDPOINT )))
    {  
        setx  EVENT_HUBS_COMPATIBILITY_ENDPOINT   $env:EVENT_HUBS_COMPATIBILITY_ENDPOINT
    }

    
    # EventHubsCompatiblePath
    If (-not([string]::IsNullOrEmpty($env:EVENT_HUBS_COMPATIBILITY_PATH )))
    {  
        setx EventHubsCompatiblePath $env:EVENT_HUBS_COMPATIBILITY_PATH
    }

    
    # EventHubsSasKey
    If (-not ([string]::IsNullOrEmpty($env:EVENT_HUBS_SAS_KEY )))
    {  
        setx EVENT_HUBS_SAS_KEY  $env:EVENT_HUBS_SAS_KEY
    }


    If (-not ([string]::IsNullOrEmpty($env:EVENT_HUBS_CONNECTION_STRING )))
    { 
       setx EVENT_HUBS_CONNECTION_STRING $env:EVENT_HUBS_CONNECTION_STRING
    }


    # The next two are only required by Device Streaming Proxy Hub

    # Remote Host Name
    If (-not ([string]::IsNullOrEmpty($env:REMOTE_HOST_NAME )))
    { 
        setx  REMOTE_HOST_NAME  $env:REMOTE_HOST_NAME
    }

    # Remote Port
    If (-not ([string]::IsNullOrEmpty($env:REMOTE_HOST_NAME )))
    { 
        setx  REMOTE_PORT $env:REMOTE_PORT
    }


    write-Host 'Done setting Environment Variables in User'
    get-anykey

    
}







