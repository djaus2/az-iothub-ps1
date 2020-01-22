param (
   [Parameter(Mandatory)]
   [string]$Prompt ,
   [Parameter(Mandatory)]
   $BG,
   [Parameter(Mandatory)]
   $FG
)
[Console]::ResetColor()
Clear-Host
$prompt =  '  A Z U R E  I o T  H U B  ' + $prompt
write-Host $prompt -BackgroundColor $BG -ForegroundColor $FG -NoNewline
write-Host ' using PowerShell AND Azure CLI'
write-Host ''
