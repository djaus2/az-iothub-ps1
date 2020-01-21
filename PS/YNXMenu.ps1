param (
   [string]$Prompt = '',
   [string]$Default =''
)

$selectionList =@('Y','N','X')
write-Host $Prompt
$prompt2 =  ' [Y]es [N]o E[x]it'
If (-not ([string]::IsNullOrEmpty($Default)))
{
    $prompt2 += ' ( Default ' + $Default + ' )'
    $selectionList =@('Y','N','X','Enter')
}
write-Host $prompt2
[boolean]$first = $true
do 
{
    # Ref: https://stackoverflow.com/questions/31603128/check-if-a-string-contains-any-substring-in-an-array-in-powershell
    $KeyPress = [System.Console]::ReadKey($true)
    $K = $KeyPress.Key

    if ( $selectionList -notcontains $K)
    {
        if ($first)
        {
            write-Host '  --Invalid' -NoNewLine
            $first = $false
        }
    }
# Ref: https://www.computerperformance.co.uk/powershell/contains/
} while ( $selectionList -notcontains $K)

if ($first -eq $false)
{
    write-Host `b`b`b`b`b`b`b -NoNewLine
    write-Host 'OK Now  ' 
}

[boolean] $def = ( $Default.ToUpper() -eq 'Y')
switch ( $k )
{
    'Y'   { return $true }
    'N'   { return $false }
    'Enter'{ return $def}
    'X'   { exit }
}
