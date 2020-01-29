function global:yes-no{
    param (
        [boolean]$Default = $false,
        [string]$Prompt = 'Select one of [Y]es [N]o'
     )
     
    if ($Default)
    {
        $prompt += ' (Default Yes)'
    }
     else 
    {
        $prompt += ' (Default No)'
    }
     
     write-Host $Prompt
     $KeyPress = [System.Console]::ReadKey($true)
     $K = $KeyPress.Key
     $KK = $KeyPress.KeyChar
     $global:retVal = $Default
     switch ($K)
     {
         Y { $global:retVal = $true} 
         N { $global:retVal =  $false}
     }
}