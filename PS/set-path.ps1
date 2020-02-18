Clear-Host

If  ([string]::IsNullOrEmpty($env:IsRedirected))
{
    if(Test-Path "\IsRemote.txt")
    {
        $env:IsRedirected ="Yes"
    }
}

$addPath =  $pwd.Path 
if (Test-Path $addPath){
    $regexAddPath = [regex]::Escape($addPath)
    $arrPath = $env:Path -split ';' | Where-Object {$_ -notMatch "^$regexAddPath\\?"}
    $env:Path = ($arrPath + $addPath) -join ';'
    If  ([string]::IsNullOrEmpty($env:IsRedirected))
    {
        $env:Path -split ';'
    }
} else {
    Throw "'$addPath' is not a valid path."
}

If  ([string]::IsNullOrEmpty($env:IsRedirected))
{
    $drive = (Get-Item $addpath).PSDrive.Name
    write-Host ''
    write-Host 'Added PWD to path. See last entry listed. This is only for this shell instance.'
    write-Host ''
    write-Host ' AZURE IOT HUB SETUP: ' -NoNewline
    write-Host '  S E T   P A T H  to current PWD '  -BackgroundColor DarkGreen  -ForegroundColor Black
    write-Host ' using PowerShell'
    write-Host ''
    write-host "Nb: DOTNET path is also set to $addPath\Quickstarts\DotNet if the file: "
    write-host  "$drive" -BackgroundColor Yellow  -ForegroundColor Black -nonewline
    write-host ":\IsEmbedded.txt" -BackgroundColor Yellow  -ForegroundColor Black
    write-host '     exists.'
    write-host ''
}


If  (-not([string]::IsNullOrEmpty($env:IsRedirected)))
{
    $dnp ="$addPath\quickstarts\dotnet"
    $addPath=$dnp
    if (Test-Path $addPath){
        $regexAddPath = [regex]::Escape($addPath)
        $arrPath = $env:Path -split ';' | Where-Object {$_ -notMatch "^$regexAddPath\\?"}
        $env:Path = ($arrPath + $addPath) -join ';'
        $env:Path -split ';'
        $env:DOTNET_ROOT = $dnp 
    } else {
        Throw "'$addPath' is not a valid path."
    }
    write-Host ''
    write-Host 'Added PWD to path.'
    write-Host 'Also added DOTNET to path as well as setting DOT_NET_ROOT to it.'
    write-host "Both at $addPath\Quickstarts\DotNet"
    write-host ' See last entries listed. These are only for this shell instance.'
    write-Host ''
    write-Host ' AZURE IOT HUB SETUP: ' -NoNewline
    write-Host '  S E T   P A T H  to current PWD and DOTNET '  -BackgroundColor DarkRed  -ForegroundColor Yellow -NoNewline
    write-Host ' using PowerShell'
    write-Host ''
}