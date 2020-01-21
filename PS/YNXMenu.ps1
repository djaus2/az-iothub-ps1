param (
   [string]$Prompt = ''
)

$selectionList =@('Y','N','X')
write-Host $Prompt
write-Host ' [Y]es [N]o E[x]it'
[boolean]$first = $true
do 
{
    # Ref: https://stackoverflow.com/questions/31603128/check-if-a-string-contains-any-substring-in-an-array-in-powershell
    $KeyPress = [System.Console]::ReadKey($false)
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
    write-Host '  OK Now  ' 
}


switch ( $k )
{
    'Y'   { return $true }
    'N'   { return $false }
    'X'   { exit }
}
