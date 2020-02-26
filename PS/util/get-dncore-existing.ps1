function get-existingdotnetcore{
    show-heading '  G E T   . N E T   C O R E   '  3

    if (-not (Test-Path "$global:ScriptDirectory\qs-apps\dotnet"))
    {
        New-Item -Path "$global:ScriptDirectory\qs-apps\dotnet" -ItemType Directory
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
           #  $target = $dpath.Replace(".zip","")
            # $target = $target.Replace(".tar.gz","")
            if ($itemsList -ne ""){
                $itemsList += ","
            }
            $target= $dpath
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

    
    if ($name -like "*.zip" ){
        # $name +='-dotnetcoresdk.zip'
        if (Test-Path "$global:ScriptDirectory\temp\$name")
        {
            write-host 'Remove folder ps\qs-apps\dotnet'
            remove-item -path "$global:ScriptDirectory\qs-apps\dotnet" -Force -Recurse -ErrorAction SilentlyContinue
            write-host 'Create folder ps\qs-apps\dotnet'
            New-Item -Path "$global:ScriptDirectory\qs-apps\dotnet" -ItemType Directory -ErrorAction SilentlyContinue
            write-host 'Please wait. Expanding archive.'
            write-host "Assuming running on Windows."
            $ch = read-host "Press [Enter] to continue. If running on Linux then exit here press N then [Enter] and expand manually to $global:ScriptDirectory\qs-apps\dotnet"
            if (-not ( [string]::IsNullOrEmpty($ch )))
            {
                return 'Back'
            }
            write-host "Please wait."
            Expand-Archive -Force -LiteralPath "$global:ScriptDirectory\temp\$name" -DestinationPath "$global:ScriptDirectory\qs-apps\dotnet"
            $RID = ((($name.Replace(".zip","")).Replace(".tar.gz","")).Replace("dotnet-sdk","")).Replace("-$global:SpecificVersion-","")
            write-host "Put note of current target in folder ps\qs-apps\dotnet as $RID.txt, contents: $name."
            Out-File -FilePath "$global:ScriptDirectory\qs-apps\dotnet\$RID.txt" -InputObject $name -Encoding ASCII
            get-anykey
        }
        else{
            write-host "Windows Archive  $global:ScriptDirectory\temp\$name doesn't exist"
            get-anykey
        }
    } else{
        #$name += '-dotnetcoresdk.tar.gz'
        if (Test-Path "$global:ScriptDirectory\temp\$name")
        {
            read-host "Using SDK binary $name  in $global:ScriptDirectory\temp\" 
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
            set-location  "$global:ScriptDirectory\qs-apps\dotnet"
            write-host "Please wait."
            tar -xzf "$global:ScriptDirectory\temp\$name"  
            set-location "$global:ScriptDirectory"
            $RID = ((($name.Replace(".zip","")).Replace(".tar.gz","")).Replace("dotnet-sdk","")).Replace("-$global:SpecificVersion-","")
            write-host "Put note of current target in folder ps\qs-apps\dotnet as $RID.txt, contents: $name."
            Out-File -FilePath "$global:ScriptDirectory\qs-apps\dotnet\$RID.txt" -InputObject $name -Encoding ASCII
            get-anykey
        }
        else{
            write-host "Linux Archive  $global:ScriptDirectory\temp\$name doesn't exist"
            get-anykey
        }     
    }
}