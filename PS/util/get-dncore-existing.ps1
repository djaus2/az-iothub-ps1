function get-existingdotnetcore{
    util\heading '  G E T   . N E T   C O R E   '  -BG DarkMagenta   -FG White

    if (-not (Test-Path "$global:ScriptDirectory\quickstarts\dotnet"))
    {
        New-Item -Path "$global:ScriptDirectory\quickstarts\dotnet" -ItemType Directory
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


    if (($answer -eq 'D1') -or ($answer -eq 'D2') -or ($answer -eq 'D3')){
        $name +='-dotnetcoresdk.zip'
        read-host $name
        if (Test-Path "$global:ScriptDirectory\temp\$name")
        {
            write-host 'Remove Quickstarts\dotnet'
            remove-item -path "$global:ScriptDirectory\quickstarts\dotnet" -Force -Recurse -ErrorAction SilentlyContinue
            write-host 'Create Quickstarts\dotnet'
            New-Item -Path "$global:ScriptDirectory\quickstarts\dotnet" -ItemType Directory -ErrorAction SilentlyContinue
            write-host 'Please wait. Expanding archive.'
            Expand-Archive -Force -LiteralPath "$global:ScriptDirectory\temp\$name" -DestinationPath "$global:ScriptDirectory\quickstarts\dotnet"
            write-host "Put note of current target in Quickstarts\dotnet as $name2.txt"
            Out-File -FilePath "$global:ScriptDirectory\quickstarts\dotnet\$name2.txt"
            get-anykey
        }
        else{
            write-host "Archive  $global:ScriptDirectory\temp\$name doesn't exist"
            get-anykey
        }
    } else{
        $name += '-dotnetcoresdk.tar.gz'
        read-host 'Linux Coming'
        # Invoke-WebRequest  -o "$global:ScriptDirectory\temp\$name" $url      
    }
}