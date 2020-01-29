   function global:press-anykey{
   param (
   [string]$Prompt = '',
   [string]$Mode =''
)
If  ( -not ([string]::IsNullOrEmpty( $Mode  )))
{
    $prompt += ' Press any key to ' + $Mode +'.'
}
else
{
    $prompt += ' Press any key to return.'
}
write-Host $prompt
[System.Console]::ReadKey($true)


return ''
}
