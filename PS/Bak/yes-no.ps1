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
     switch ($K)
     {
         Y { return $true}
         N { return $false}
         Default {return $Default}
     }
}