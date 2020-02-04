function get-anykey{
param (
[string]$Prompt = '',
[string]$Mode =''
)
    If  (  ([string]::IsNullOrEmpty( $Prompt  )))
    {
        If  ( -not ([string]::IsNullOrEmpty( $Mode  )))
        {
            $prompt += ' Press any key to ' + $Mode +'.'
        }
        else
        {
            $prompt += ' Press any key to return.'
        }
    }
    elseIf  ( -not ([string]::IsNullOrEmpty( $Mode  )))
    {
        $prompt += $Mode +'.'
    }
   
    write-Host $prompt
    [System.Console]::ReadKey($true)
}
