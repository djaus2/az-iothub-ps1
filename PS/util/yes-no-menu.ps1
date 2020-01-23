param (
   [string]$Prompt = 'Select one of: ',
   [string]$Default =''
)


write-Host $Prompt
$SelectionList = ('Y','N')
$ValidKeys ='[Y]es [N]o'
If (-not ([string]::IsNullOrEmpty($Default)))
{
    if  ($SelectionList -contains $Default) {
        $SelectionList = ('Y','No','Enter')
        $ValidKeys += ' ( Default ' + $Default + ' )'
    }
    else {
        write-Host 'Default can only be Y or N with this verion of the menu'
    }
}
write-Host $ValidKeys
$first = $true
do 
{
    # Ref: https://stackoverflow.com/questions/31603128/check-if-a-string-contains-any-substring-in-an-array-in-powershell
    # Ref https://stackoverflow.com/questions/25768509/read-individual-key-presses-in-powershell
    $KeyPress = [System.Console]::ReadKey($true)
    $K = $KeyPress.Key

    if ( $SelectionList -notcontains $K){
        if ($first){
            write-Host '  --Invalid' -NoNewLine
            $first = $false
        }
    }
# Ref: https://www.computerperformance.co.uk/powershell/contains/
} while ( $SelectionList -notcontains $K)

if ($first -eq $false)
{
    write-Host `b`b`b`b`b`b`b -NoNewLine
    write-Host 'OK Now  ' 
}

switch ( $k )
{
    Y  {$val = $true  }
    N  {$val = $false  }
    Default {$val =  $Default}
}

return $val

