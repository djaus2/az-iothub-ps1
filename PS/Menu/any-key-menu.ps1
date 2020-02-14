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
   
    write-Host $prompt

    If ([string]::IsNullOrEmpty( $env:IsRedirected  ))
    {
    $keypress = [System.Console]::ReadKey($true)
    }
    else {
        read-Host
    }
}
