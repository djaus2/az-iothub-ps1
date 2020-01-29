Clear-Host

$addPath =  $pwd.Path 
if (Test-Path $addPath){
    $regexAddPath = [regex]::Escape($addPath)
    $arrPath = $env:Path -split ';' | Where-Object {$_ -notMatch "^$regexAddPath\\?"}
    $env:Path = ($arrPath + $addPath) -join ';'
    $env:Path -split ';'
} else {
    Throw "'$addPath' is not a valid path."
}
write-Host ''
write-Host 'Added PWD to path. See last entry listed. This is only for this shell instance.'
write-Host ''
write-Host ' AZURE IOT HUB SETUP: ' -NoNewline
write-Host '  S E T   P A T H  to current PWD '  -BackgroundColor DarkGreen  -ForegroundColor White -NoNewline
write-Host ' using PowerShell'
write-Host ''