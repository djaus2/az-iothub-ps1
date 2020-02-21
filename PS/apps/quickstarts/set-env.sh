#!/bin/bash
# Assumes run from Quickstarts. But assumes .NET Core is in Home/usr/dotnet
export DOTNET_ROOT='~/dotnet'
export PATH=$PATH:~/dotnet
export SHARED_ACCESS_KEY_NAME=iothubowner
export DEVICE_NAME=DSDevice
export IOTHUB_DEVICE_CONN_STRING='HostName=DSHub.azure-devices.net;DeviceId=DSDevice;SharedAccessKey=zmqi3bBMucAfxjckqeh69T7oVlqeC/cFOtW4OsFjbPY='
export IOTHUB_CONN_STRING_CSHARP='HostName=DSHub.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=4u6450XZT2duPjlcq7RHS8DGGAVtnHcKEIXFo5Vtiak='
export SERVICE_CONNECTION_STRING='HostName=DSHub.azure-devices.net;SharedAccessKeyName=service;SharedAccessKey=GJn88d5PAoWtbtHojUDX0e/DPF7NEd4qIJwDDj/Nck8='
export DEVICE_ID=DSDevice
export EVENT_HUBS_COMPATIBILITY_ENDPOINT='sb://iothub-ns-dshub-2908772-b212bea2d9.servicebus.windows.net/'
export EVENT_HUBS_COMPATIBILITY_PATH=dshub
export EVENT_HUBS_SAS_KEY='4u6450XZT2duPjlcq7RHS8DGGAVtnHcKEIXFo5Vtiak='
export EVENT_HUBS_CONNECTION_STRING='Endpoint=sb://iothub-ns-qwerty-2862278-31b54ca8c2.servicebus.windows.net/;SharedAccessKeyName=iothubowner;SharedAccessKey=kVFKa00TrE6ExALK1CRSviyppoioTXhp4A2O3j5jd4Q=;EntityPath=qwerty'
export REMOTE_HOST_NAME=localhost
export REMOTE_PORT=2222