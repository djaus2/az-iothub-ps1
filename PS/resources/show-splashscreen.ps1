
function Show-Splashscreen{
  [Console]::ResetColor()
   Clear-Host
   write-host ''
   write-host '               Az-IoTHub-PS' -ForegroundColor Red
   write-host ''
   write-host '         Azure CLI IoT Hub PowerShell   '  -ForegroundColor Yellow
   write-host ''
   write-host '   Create an IoT Hub or select an existing one'  -ForegroundColor DarkCyan
   write-host 'Get Connection Strings as Environment Variables.' -ForegroundColor DarkCyan
   write-host '       Run IoT Hub Quickstarts using such.' -ForegroundColor DarkCyan
   write-host '    All in one script with prompts and menus.' -ForegroundColor DarkCyan
   write-host ''
   write-host 'GitHub: ' -NoNewLine -ForegroundColor White
   write-host 'https://github.com/djaus2/az-iothub-ps' -ForegroundColor Yellow
   write-host ''
   write-host 'Blog: ' -NoNewLine -ForegroundColor White
   write-host 'http://www.sportronics.com.au' -ForegroundColor Yellow
   write-host ''
   get-anykey '' 'Continue'
   [Console]::ResetColor()
   Clear-Host
}

