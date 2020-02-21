function get-existingdotnetcore{
    util\heading '  G E T   . N E T   C O R E   '  -BG DarkMagenta   -FG White

    if (-not (Test-Path "$global:ScriptDirectory\apps\dotnet"))
    {
        New-Item -Path "$global:ScriptDirectory\apps\dotnet" -ItemType Directory
    }
    if (-not (Test-Path "$global:ScriptDirectory\temp"))
    {
        write-host 'No previous .NET Core SDKs downloads available'
        get-anykey
        retrun 'Back'
    }

    $itemsList ='ARM32-Windows10,x64-Windows10,x86-Windows10,ARM32-Linux,ARM64-Linux,X64-Linux,Done'


    $items = Get-ChildItem  -File -path "$global:ScriptDirectory\temp\" | select Name|  out-string
    $itemsList1= $items -split '\n' | Sort-Object -Descending
    $itemsList = ""
    foreach ($dpath in $itemsList1)
    {
        $dpath = $dpath.Trim()
        If ([string]::IsNullOrEmpty($dpath ))
        {
            continue
        }
        elseif (($dpath -eq "Name") -or ($dpath -eq "----"))
        {
            continue
        }
        else {
            $target = $dpath.Replace("-dotnetcoresdk.zip","")
            $target = $target.Replace("-dotnetcoresdk.tar.gz","")
            if ($itemsList -ne ""){
                $itemsList += ","
            }
            $itemsList += $target
        }
    }
    
    choose-selection $itemsList  'Manage App Data Action'   '' ','
    $answer = $global:retVal1
    if ( $global:retVal -eq 'Back'){
        return  'Back'
    }


    $url = $WiNARM32
    $name = "$global:retVal"
    $name2 = $name

    
    if ($name -like "*Windows*" ){
        $name +='-dotnetcoresdk.zip'
        if (Test-Path "$global:ScriptDirectory\temp\$name")
        {
            write-host 'Remove folder ps\apps\dotnet'
            remove-item -path "$global:ScriptDirectory\apps\dotnet" -Force -Recurse -ErrorAction SilentlyContinue
            write-host 'Create folder ps\apps\dotnet'
            New-Item -Path "$global:ScriptDirectory\apps\dotnet" -ItemType Directory -ErrorAction SilentlyContinue
            write-host 'Please wait. Expanding archive.'
            write-host "Assuming running on Windows."
            $ch = read-host "Press [Enter] to continue. If running on Linux then exit here press N then [Enter] and expand manually to $global:ScriptDirectory\apps\dotnet"
            if (-not ( [string]::IsNullOrEmpty($ch )))
            {
                return 'Back'
            }
            Expand-Archive -Force -LiteralPath "$global:ScriptDirectory\temp\$name" -DestinationPath "$global:ScriptDirectory\apps\dotnet"
            write-host "Put note of current target in folder ps\apps\dotnet as $name2.txt"
            Out-File -FilePath "$global:ScriptDirectory\apps\dotnet\$name2.txt"
            get-anykey
        }
        else{
            write-host "Windows Archive  $global:ScriptDirectory\temp\$name doesn't exist"
            get-anykey
        }
    } else{
        $name += '-dotnetcoresdk.tar.gz'
        if (Test-Path "$global:ScriptDirectory\temp\$name")
        {
            read-host "Using SDK binary $name  in $global:ScriptDirectory\temp\" 
            write-host 'Remove folder ps\apps\dotnet'
            remove-item -path "$global:ScriptDirectory\apps\dotnet" -Force -Recurse -ErrorAction SilentlyContinue
            write-host 'Create folder ps\apps\dotnet'
            New-Item -Path "$global:ScriptDirectory\apps\dotnet" -ItemType Directory -ErrorAction SilentlyContinue
            write-host "Please wait. Expanding archive. to $global:ScriptDirectory\apps\dotnet"
            write-host "Assuming running on Windows."
            $ch = read-host "Press [Enter] to continue. If running on Linux then exit here press N then [Enter] and expand manually to $global:ScriptDirectory\apps\dotnet"
            if (-not ( [string]::IsNullOrEmpty($ch )))
            {
                return 'Back'
            }
            set-location  "$global:ScriptDirectory\apps\dotnet"
            tar -xzf "$global:ScriptDirectory\temp\$name"  
            set-location "$global:ScriptDirectory"
            write-host "'Put note of current target in ps\apps\dotnet as $name2.txt"
            Out-File -FilePath "$global:ScriptDirectory\apps\dotnet\$name2.txt" 
        }
        else{
            write-host "Linux Archive  $global:ScriptDirectory\temp\$name doesn't exist"
            get-anykey
        }     
    }
}