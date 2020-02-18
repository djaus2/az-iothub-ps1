
# This script meant to run in the specific Quickstart folder: Quickstarts\Telemetry\telemetry.
$global:ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$dnp = "..\..\dotnet"
if (Test-Path $dnp){
     $regexAddPath = [regex]::Escape($dp)
     $arrPath = $env:Path -split ";" | Where-Object {$_ -notMatch "^$regexAddPath\\?"}
     $env:Path = ($arrPath + $dnp) -join ";" 
     $env:DOT_NET_ROOT = $dnp
} else {
    Throw "$dnp is not a valid path."
}
$env:SHARED_ACCESS_KEY_NAME = "iothubowner"
$env:DEVICE_NAME = "DSDevice"
$env:IOTHUB_DEVICE_CONN_STRING = "HostName=DSHub.azure-devices.net;DeviceId=DSDevice;SharedAccessKey=zmqi3bBMucAfxjckqeh69T7oVlqeC/cFOtW4OsFjbPY="
$env:IOTHUB_CONN_STRING_CSHARP = "HostName=DSHub.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=4u6450XZT2duPjlcq7RHS8DGGAVtnHcKEIXFo5Vtiak="
$env:SERVICE_CONNECTION_STRING = "HostName=DSHub.azure-devices.net;SharedAccessKeyName=service;SharedAccessKey=GJn88d5PAoWtbtHojUDX0e/DPF7NEd4qIJwDDj/Nck8="
$env:DEVICE_ID = "DSDevice"
$env:EVENT_HUBS_COMPATIBILITY_ENDPOINT = "sb://iothub-ns-dshub-2908772-b212bea2d9.servicebus.windows.net/"
$env:EVENT_HUBS_COMPATIBILITY_PATH = "dshub"
$env:EVENT_HUBS_SAS_KEY = "4u6450XZT2duPjlcq7RHS8DGGAVtnHcKEIXFo5Vtiak="
$env:EVENT_HUBS_CONNECTION_STRING = "Endpoint=sb://iothub-ns-qwerty-2862278-31b54ca8c2.servicebus.windows.net/;SharedAccessKeyName=iothubowner;SharedAccessKey=kVFKa00TrE6ExALK1CRSviyppoioTXhp4A2O3j5jd4Q=;EntityPath=qwerty"
$env:REMOTE_HOST_NAME = "localhost"
$env:REMOTE_PORT = 2222
