$thisFile="unsignall.ps1"
# BEGIN
# LOGGING
# Ref: https://serveranalyst.wordpress.com/2011/11/12/code-signing-multiple-powershell-scripts/
# Modified here for removing signature from .ps1
$logpath = "C:\logs"
 
$Outputfile = "{0}\{1:yyyy.MM.dd-hh.mm.ss}-unsign-scripts.txt" -f $logpath, $(Get-Date)
 
$starttime = Get-Date
write-output "**** script start $starttime ****"" | Out-File $Outputfile -append
 
# Change to our working Directory

$global:ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

write-host "Recursing this directory:"
read-host $global:ScriptDirectory 

write-output "**** script start $global:ScriptDirectory **** | Out-File $Outputfile -append

$scriptdir = $global:ScriptDirectory

 
# Search for all Scripts, get their contents and save them using UTF8
 
$scripts = get-childitem -recurse | where-object{($_.Extension -ieq '.PS1')}
 
write-host "Getting List"
$list = @()
foreach ($script in $scripts)
{
    $list += $script.fullname
    $script.fullname
}
write-host "Got List"
foreach($File in $list){
    $fileout = "$file"
    $contentsSigned = get-content $file 
    $n = [array]::indexof($contentsSigned,"# SIG # Begin signature block")
    if ($n -lt 1) {
        write-host 'No signature'
        continue
    }
    $n -=1
    $contentsUnsigned = $contentsSigned[0 .. $n]| out-string
    if ( Test-Path -Path $fileout){
      remove-item "$Fileout"
	}
    Set-Content "$fileout" -Value $contentsUnsigned
}
 
 
$finishtime = Get-Date
write-output "**** script finished $finishtime ****" | Out-File $Outputfile -append
 
#END














