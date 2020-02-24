function get-name{
param (
    [string]$Title = '' 
)
    $answer =''
    do
    {
        $prompt = 'Enter ' + $Title + ' Name, B to return'
        $answer= read-Host $prompt
        $answer = $answer.Trim()
        write-Host $answer     
    } until (-not ([string]::IsNullOrEmpty($answer)))
    if ($answer.ToUpper() -eq 'B')
    {
        return 'Back'
    }
    return $answer
}