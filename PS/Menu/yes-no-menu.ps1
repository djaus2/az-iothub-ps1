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
     
     

    show-time
     $K=$null

     If  ([string]::IsNullOrEmpty($env:IsRedirected))
     {
        If (-not ([string]::IsNullOrEmpty($global:yesnowait )))
         {
             if ($default)
             {
                Write-Host "Pausing for $global:yesnowait secs. Taking Yes as the answer." 
                start-sleep $global:yesnowait    
             }
             else{
                write-Host $Prompt
                $KeyPress = [System.Console]::ReadKey($true)
                $K = $KeyPress.Key
             }          
         }
         else {
            write-Host $Prompt
            $KeyPress = [System.Console]::ReadKey($true)
            $K = $KeyPress.Key
        }
     } else {
        write-Host $Prompt
         $response = Read-Host
         If  ([string]::IsNullOrEmpty($response))
         {
            $k =' '
         } else{   
            $K = $response[0]
         }

     }

     $global:retVal = $Default

     If (-not ([string]::IsNullOrEmpty($K )))
     {  
        switch ($K)
        {
            Y { $global:retVal = $true} 
            N { $global:retVal =  $false}
        }
    }
     # return $global:retVal
}