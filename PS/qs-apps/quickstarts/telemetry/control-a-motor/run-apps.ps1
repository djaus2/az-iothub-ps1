set-location simulated-device-2
Start-process dotnet run
set-location ..\back-end-application
start-process dotnet run
set-location ..\read-d2c-messages
start-process dotnet run
set-location ..
