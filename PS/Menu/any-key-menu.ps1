function get-anykey{
param (
[string]$Prompt = '',
[string]$Mode =''
)
    If  (  ([string]::IsNullOrEmpty( $Prompt  )))
    {
        If  ( -not ([string]::IsNullOrEmpty( $Mode  )))
        {
            If   ([string]::IsNullOrEmpty( $env:IsRedirected  ))
            {
                $prompt = ' Press any key to ' + $Mode +'.'
            }
            else{
                $prompt = ' Press [Enter] to ' + $Mode +'.'
            }
        }
        else
        {
            If  ([string]::IsNullOrEmpty( $env:IsRedirected  ))
            {
                $prompt = ' Press any key to return.'
            }
            else{
                $prompt = ' Press [Enter] to  return.'
            }
        }
    }
    elseIf  ( -not ([string]::IsNullOrEmpty( $Mode  )))
    {
        $prompt += ' ' + $Mode +'.'
    }
    else{
        
        If  ([string]::IsNullOrEmpty( $env:IsRedirected  ))
        {
            $prompt += ' Press any key to return.'
        }
        else{
            $prompt += ' Press [Enter] to  return.'
        }
    }
   
    

    If ([string]::IsNullOrEmpty( $env:IsRedirected  ))
    {
        write-Host $prompt
       
        If (-not ([string]::IsNullOrEmpty($global:yesnowait )))
        {
               Write-Host "Pausing for $global:yesnowait secs" 
               start-sleep $global:yesnowait           
        }
        else {
            [System.Console]::ReadKey($true) >$null
       }
    }
    else {
        read-Host $prompt >$null
    }
}
