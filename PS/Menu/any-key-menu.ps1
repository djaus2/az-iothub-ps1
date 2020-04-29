function get-anykey{
param (
[string]$Prompt = '',
[string]$Mode ='',
[boolean]$TimeStamp =$true
)
    $promptParam = $prompt
    if ($TimeStamp)
    {
        show-time
    }
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
        
       
        If (-not ([string]::IsNullOrEmpty($global:yesnowait )))
        {
            If  ( -not ([string]::IsNullOrEmpty( $Mode  )))
            {
                write-host $promptParam
            }
            if (-not $global:dontshowait)
            {
                Write-Host "Pausing for $global:yesnowait secs" 
            }
            start-sleep $global:yesnowait           
        }
        else {
            write-Host $prompt
            [System.Console]::ReadKey($true) >$null
       }
    }
    else {
        read-Host $prompt >$null
    }
}
