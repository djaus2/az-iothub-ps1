set-location .\read-d2c-messages
start-process dotnet run
set-location ..
[System.Threading.Thread]::Sleep(2000)

set-location .\simulated-device
Start-process dotnet run
set-location ..
