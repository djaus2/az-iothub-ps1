function get-yesorno{
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



     If  ([string]::IsNullOrEmpty($env:IsRedirected))
     {
         $KeyPress = [System.Console]::ReadKey($true)
         $K = $KeyPress.Key
     } else {
         $response = Read-Host
         If  ([string]::IsNullOrEmpty($response))
         {
            $k =' '
         } else{   
            $K = $response[0]
         }

     }

     $global:retVal = $Default
     switch ($K)
     {
         Y { $global:retVal = $true} 
         N { $global:retVal =  $false}
     }
     # return $global:retVal
}