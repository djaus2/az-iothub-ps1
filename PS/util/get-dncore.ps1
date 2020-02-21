function Expand-Tar($tarFile, $dest) {
# Ref: https://stackoverflow.com/questions/38776137/native-tar-extraction-in-powershell
    if (-not (Get-Command Expand-7Zip -ErrorAction Ignore)) {
        Install-Package -Scope CurrentUser -Force 7Zip4PowerShell > $null
    }

    Expand-7Zip $tarFile $dest
    # Expand with Expand-7Zip $tarFile $dest
}
function get-dotnetcore{
    util\heading '  G E T   . N E T   C O R E   '  -BG DarkMagenta   -FG White

    if (-not (Test-Path "$global:ScriptDirectory\qs-apps\dotnet"))
    {
        New-Item -Path "$global:ScriptDirectory\qs-apps\dotnet" -ItemType Directory
    }
    if (-not (Test-Path "$global:ScriptDirectory\temp"))
    {
        New-Item -Path "$global:ScriptDirectory\temp" -ItemType Directory
    }

    $itemsList ='ARM32-Windows10,x64-Windows10,x86-Windows10,ARM32-Linux,ARM64-Linux,X64-Linux,Done'

    $WiNARM32 ="https://download.visualstudio.microsoft.com/download/pr/7363a148-a9e0-4393-b0f6-4e51ecba3e27/4b28aec090c9854d71925bb6d50c8314/dotnet-sdk-3.1.101-win-arm.zip"
    $WiNx64 ="https://download.visualstudio.microsoft.com/download/pr/87955c8d-c571-471a-9d2d-90fd069cf1f2/9fbde37bbe8b156cec97a25b735f9465/dotnet-sdk-3.1.101-win-x64.zip"
    $Winx86 = "https://download.visualstudio.microsoft.com/download/pr/961d2276-c171-4e2b-b74c-e5fbc71f308c/2590499670296b16c02fb38441053d79/dotnet-sdk-3.1.102-win-x86.zip"
    $LinuxARM32="https://download.visualstudio.microsoft.com/download/pr/d52fa156-1555-41d5-a5eb-234305fbd470/173cddb039d613c8f007c9f74371f8bb/dotnet-sdk-3.1.101-linux-arm.tar.gz"
    $LinuxARM64 = "https://download.visualstudio.microsoft.com/download/pr/cf54dd72-eab1-4f5c-ac1e-55e2a9006739/d66fc7e2d4ee6c709834dd31db23b743/dotnet-sdk-3.1.101-linux-arm64.tar.gz"
    $Linuxx64 = "https://download.visualstudio.microsoft.com/download/pr/57e63f03-ebdf-4c22-96ff-2b85dc70cf7f/988576869e82a80f4a97ca5a733a5295/dotnet-sdk-3.1.102-linux-x64.tar.gz"

    choose-selection $itemsList  'Manage App Data Action'   '' ','
    $answer = $global:retVal1
    if ( $global:retVal -eq 'Back'){
        return  'Back'
    }


    $url = $WiNARM32
    $name = "$global:retVal"
    $name2= $name

    switch ($answer)
    {
        'D1'    {  $url = $WiNARM32 }
        'D2'    {  $url = $Winx64 }
        'D3'    {  $url = $WiNx86}
        'D4'    {  $url = $LinuxARM32 }
        'D5'    {  $url = $LinuxARM64 }
        'D4'    {  $url = $Linuxx64 }
        'D5'    {  return 'Back' }
    }  

    if ($answer -like "*windows*" ){
        $name +='-dotnetcoresdk.zip'
        write-host "Downloading SDK binary as $name  to $global:ScriptDirectory\temp\"
        write-host "Please wait."
        Invoke-WebRequest -o "$global:ScriptDirectory\temp\$name" $url
        write-host 'Remove folder ps\qs-apps\dotnet'
        remove-item -path "$global:ScriptDirectory\qs-apps\dotnet" -Force -Recurse -ErrorAction SilentlyContinue
        write-host 'Create folder ps\qs-apps\dotnet'
        New-Item -Path "$global:ScriptDirectory\qs-apps\dotnet" -ItemType Directory -ErrorAction SilentlyContinue
        write-host "Please wait. Expanding archive. to $global:ScriptDirectory\qs-apps\dotnet"
        write-host "Assuming running on Windows."
        $ch = read-host "Press [Enter] to continue. If running on Linux then exit here press N then [Enter] and expand manually to $global:ScriptDirectory\qs-apps\dotnet"
        if (-not ( [string]::IsNullOrEmpty($ch )))
        {
            return 'Back'
        }
        if (-not (Test-Path "$global:ScriptDirectory\temp\$name"))
        {
            write-host "File not found : $global:ScriptDirectory\temp\$name "
            get-anykey
            return 'Back'
        }
        Expand-Archive -Force -LiteralPath "$global:ScriptDirectory\temp\$name" -DestinationPath "$global:ScriptDirectory\qs-apps\dotnet"
        write-host"'Put note of current target in folder ps\qs-apps\dotnet as $name2.txt"
        Out-File -FilePath "$global:ScriptDirectory\qs-apps\dotnet\$name2.txt"
    } else{
        $name += '-dotnetcoresdk.tar.gz'
        write-host "Downloading SDK binary as $name  to $global:ScriptDirectory\temp\"
        write-host "Please wait."
        Invoke-WebRequest  -o "$global:ScriptDirectory\temp\$name" $url   
        write-host 'Remove folder ps\qs-apps\dotnet'
        remove-item -path "$global:ScriptDirectory\qs-apps\dotnet" -Force -Recurse -ErrorAction SilentlyContinue
        write-host 'Create folder ps\qs-apps\dotnet'
        New-Item -Path "$global:ScriptDirectory\qs-apps\dotnet" -ItemType Directory -ErrorAction SilentlyContinue
        write-host "Please wait. Expanding archive. to $global:ScriptDirectory\qs-apps\dotnet"
        write-host "Assuming running on Windows."
        $ch = read-host "Press [Enter] to continue. If running Linux then exit here [N} then [Enter] and expand manually to $global:ScriptDirectory\qs-apps\dotnet"
        if (-not ( [string]::IsNullOrEmpty($ch )))
        {
            return 'Back'
        }
        if (-not (Test-Path "$global:ScriptDirectory\temp\$name"))
        {
            write-host "File not found : $global:ScriptDirectory\temp\$name "
            get-anykey
            return 'Back'
        }
        set-location  "$global:ScriptDirectory\qs-apps\dotnet"
        tar -xzf "$global:ScriptDirectory\temp\$name"  
        set-location "$global:ScriptDirectory"
        write-host"'Put note of current target in folder ps\qs-apps\dotnet as $name2.txt"
        Out-File -FilePath "$global:ScriptDirectory\qs-apps\dotnet\$name2.txt"

    }
}