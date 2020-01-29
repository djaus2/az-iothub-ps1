function global:KP{
    param (
        [string]$Prompt = 'Select one of: ',
        [boolean]$Default = $false
     )
     
     
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