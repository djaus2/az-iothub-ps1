function Expand-Tar($tarFile, $dest) {
# Ref: https://stackoverflow.com/questions/38776137/native-tar-extraction-in-powershell
    if (-not (Get-Command Expand-7Zip -ErrorAction Ignore)) {
        Install-Package -Scope CurrentUser -Force 7Zip4PowerShell > $null
    }

    Expand-7Zip $tarFile $dest
    # Expand with Expand-7Zip $tarFile $dest
}
function get-dotnetcore{
    show-heading '  G E T   . N E T   C O R E   '  -BG DarkMagenta   -FG White

    if (-not (Test-Path "$global:ScriptDirectory\qs-apps\dotnet"))
    {
        New-Item -Path "$global:ScriptDirectory\qs-apps\dotnet" -ItemType Directory
    }
    if (-not (Test-Path "$global:ScriptDirectory\temp"))
    {
        New-Item -Path "$global:ScriptDirectory\temp" -ItemType Directory
    }

    if ( $null -eq $global:Urls)
    {
        $links = (invoke-webrequest https://dotnet.microsoft.com/download/dotnet-core/3.1).Links
        $binaries = $links.where{($_.href).Contains("binaries")}
        $sdks= $binaries.where{($_.href).Contains("sdk")}
        $global:urls=$sdks.where{($_.href).Contains($global:SpecificVersion)}
    }
    

    $itemsList ='windows-arm32,windows-x64,windows-x86,linux-arm32,linux-arm64,linux-x64,macos-x64,Done'
    if ($false) { RIDs Ref: https://docs.microsoft.com/en-us/dotnet/core/rid-catalog
        win-x64
win-x86
win-arm
win-arm64
linux-arm
linux-x64
osx.10.14-x64
    }


    choose-selection $itemsList  ' .NET Core Target'   '' ','
    $answer = $global:retVal1
    if ( $global:retVal -eq 'Back'){
        return  'Back'
    }


    $link= $global:Urls.where{($_.href).Contains($global:retVal)}


    $name = "$global:retVal"

    $url1=$link.href
    $url2="https://dotnet.microsoft.com$url1"

    $links2 = (invoke-webrequest $url2).Links
    $url3=$links2.where{ $_.innerText  -eq "click here to download manually"}
    $url=$url3.href



    

    if ($url -like "*win*" ){
        $parts = $url.Split('/')
        $len = $parts.Length
        $name = $parts[$len-1]
        read-host $name
        write-host "Downloading SDK binary from $url"
        write-host "... as $name  to $global:ScriptDirectory\temp\"
        get-anykey "" "Continue"
        write-host "Please wait."
        Invoke-WebRequest -o "$global:ScriptDirectory\temp\$name" $url
        write-host 'Remove folder ps\qs-apps\dotnet'
        remove-item -path "$global:ScriptDirectory\qs-apps\dotnet" -Force -Recurse -ErrorAction SilentlyContinue
        write-host 'Create folder ps\qs-apps\dotnet'
        New-Item -Path "$global:ScriptDirectory\qs-apps\dotnet" -ItemType Directory -ErrorAction SilentlyContinue
        write-host "Expanding archive. to $global:ScriptDirectory\qs-apps\dotnet"
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
        write-host "Please wait."
        Expand-Archive -Force -LiteralPath "$global:ScriptDirectory\temp\$name" -DestinationPath "$global:ScriptDirectory\qs-apps\dotnet"
        $RID = ((($name.Replace(".zip","")).Replace(".tar.gz","")).Replace("dotnet-sdk","")).Replace("-$global:SpecificVersion-","")
        write-host "Put note of current target in folder ps\qs-apps\dotnet as $RID.txt, contents: $name."
        Out-File -FilePath "$global:ScriptDirectory\qs-apps\dotnet\$RID.txt" -InputObject $name -Encoding ASCII
        get-anykey
    } elseif ($url -like "*linux*" ){
        $parts = $url.Split('/')
        $len = $parts.Length
        $name = $parts[$len-1]
        write-host "Downloading SDK binary from $url"
        write-host "... as $name  to $global:ScriptDirectory\temp\"
        get-anykey "" "Continue"
        write-host "Please wait."
        Invoke-WebRequest  -o "$global:ScriptDirectory\temp\$name" $url   
        write-host 'Remove folder ps\qs-apps\dotnet'
        remove-item -path "$global:ScriptDirectory\qs-apps\dotnet" -Force -Recurse -ErrorAction SilentlyContinue
        write-host 'Create folder ps\qs-apps\dotnet'
        New-Item -Path "$global:ScriptDirectory\qs-apps\dotnet" -ItemType Directory -ErrorAction SilentlyContinue
        write-host "Expanding archive. to $global:ScriptDirectory\qs-apps\dotnet"
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
        write-host "Please wait."
        tar -xzf "$global:ScriptDirectory\temp\$name"  
        set-location "$global:ScriptDirectory"
        $RID = ((($name.Replace(".zip","")).Replace(".tar.gz","")).Replace("dotnet-sdk","")).Replace("-$global:SpecificVersion-","")
        write-host "Put note of current target in folder ps\qs-apps\dotnet as $RID.txt, , contents: $name."
        Out-File -FilePath "$global:ScriptDirectory\qs-apps\dotnet\$RID.txt" -InputObject $name -Encoding ASCII
        get-anykey

    } else{
        write-host "Url for download not found. Could add mac here."
        get-anykey
    }
}