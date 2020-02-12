param (
   [Parameter(Mandatory)]
   [string]$Prompt ,
   [Parameter(Mandatory)]
   $BG,
   [Parameter(Mandatory)]
   $FG
)
[Console]::ResetColor()
#If ( -not ([string]::IsNullOrEmpty($global:DontClearOnHeading )) )
#{
  #  Clear-Host
#}
$prompt2 =  '  A Z U R E  I o T  H U B  ' 
write-Host $prompt2 -BackgroundColor  DarkMagenta  -ForegroundColor   White  -NoNewline
[Console]::ResetColor()
write-Host ' '  -NoNewline
write-Host $prompt -BackgroundColor $BG -ForegroundColor $FG -NoNewline
[Console]::ResetColor()
write-Host ' using PowerShell AND Azure CLI'
write-Host ''
