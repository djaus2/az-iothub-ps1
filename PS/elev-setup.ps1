# Check if session is elevated
# a work in progress don't use
[bool]$isElevated = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($isElevated)
{
	Write-Host 'Session is elevated - We can Continue'
    $  .\add-path
}
else
{
	# Start a new elevated PowerShell session
	$sdf = "-file $pwd.Path\aa.ps1" 
	$sdf
	Start-Process -FilePath PowerShell.exe -ArgumentList $sdf  -Verb Runas
}
