# .\set-env
cd device
Start-process dotnet run
cd ..\service
start-process dotnet run
cd ..
