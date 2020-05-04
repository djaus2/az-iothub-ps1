$thisFile="signall.ps1"
# BEGIN
# LOGGING
# Ref: https://serveranalyst.wordpress.com/2011/11/12/code-signing-multiple-powershell-scripts/
$logpath = "C:\logs"
 
$Outputfile = "{0}\{1:yyyy.MM.dd-hh.mm.ss}-sign-scripts.txt" -f $logpath, $(Get-Date)
 
$starttime = Get-Date
write-output "**** script start $starttime ****"" | Out-File $Outputfile -append
 
# Change to our working Directory

$global:ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

write-Host $global:ScriptDirectory
write-output "**** script start $global:ScriptDirectory **** | Out-File $Outputfile -append

$scriptdir = $global:ScriptDirectory

write-host "Recursing this directory:"
read-host $global:ScriptDirectory 
 
# Search for all Scripts, get their contents and save them using UTF8
 
$scripts = get-childitem -recurse | where-object{($_.Extension -ieq '.PS1')}

Write-host "Getting List"
$list = @()
foreach ($script in $scripts)
{
    $list += $script.fullname
    $script.fullname
}
write-host "Got List"
foreach($File in $list){
    $TempFile = “$($File).UTF8"
    get-content $File | out-file $TempFile -Encoding UTF8
    remove-item $File
    rename-item $TempFile $File
}
 
# Search the local machine for an installed code sign certificate
$cert = Get-ChildItem cert:\CurrentUser\my -codesigning
 
# Search for all Scripts

write-host "Appending Certificate to files"
$Files = Get-ChildItem $scriptdir *.ps1 -Recurse
 
# For each file found get its file path and sign the script
Foreach($file in $Files) {
$a = $file.fullname
Set-AuthenticodeSignature -filepath $a -Certificate $cert -IncludeChain ALL -force | Out-File $Outputfile -append
}
 
$finishtime = Get-Date
write-output "**** script finished $finishtime ****" | Out-File $Outputfile -append
 
#END














