param (
   [string]$Prompt = 'Select one of: ',
   [string]$ValidKeys = ' [Y]es [N]o ', 
   [object]$SelectionList =@('Y','N'),
   [string]$Default =''
)


write-Host $Prompt
# https://www.jonathanmedd.net/2014/01/adding-and-removing-items-from-a-powershell-array.html
[System.Collections.ArrayList]$ModifyableSelectionList = $SelectionList
If (-not ([string]::IsNullOrEmpty($Default)))
{
    $ModifyableSelectionList.Add('Enter')
    $ValidKeys += ' ( Default ' + $Default + ' )'
}
$ModifyableSelectionList.Add({D1})
write-Host $ValidKeys

[boolean]$first = $true
do 
{
    # Ref: https://stackoverflow.com/questions/31603128/check-if-a-string-contains-any-substring-in-an-array-in-powershell
    # Ref https://stackoverflow.com/questions/25768509/read-individual-key-presses-in-powershell
    $KeyPress = [System.Console]::ReadKey($true)
    $K = $KeyPress.Key
    $K.GetType()

    if ( $ModifyableSelectionList -notcontains $K)
    {
        if ($first)
        {
            write-Host '  --Invalid' -NoNewLine
            $first = $false
        }
    }
# Ref: https://www.computerperformance.co.uk/powershell/contains/
} while ( $ModifyableSelectionList -notcontains $K)

if ($first -eq $false)
{
    write-Host `b`b`b`b`b`b`b -NoNewLine
    write-Host 'OK Now  ' 
}

$val = $null
if ($k -eq {Enter})
{
    $val = $Default
}
else {
    switch ( $k )
    {
        # Numerical Keys 0 to 9
        'D1'  {$val = '0'  }
        'D1'  {$val = '1'  }
        'D2'  {$val = '2'  }
        'D3'  {$val = '3'  }
        'D4'  {$val = '4'  }
        'D5'  {$val = '5'  }
        'D6'  {$val = '6'  }
        'D7'  {$val = '7'  }
        'D8'  {$val = '8'  }
        'D9'  {$val = '9'  }
        Default {$val = [char]$k}
    }
}

write-Host $val



$global:ReturnValue = $val

$k =D1
$val = [char]$k
write-Host $val

return

