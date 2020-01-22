param (
   [string]$Prompt = 'Select one of: ',
   [string]$ValidKeys = ' [Y]es [N]o ', 
   [object]$SelectionList =@('Y','N'),
   [string]$Default =''
)

# https://www.jonathanmedd.net/2014/01/adding-and-removing-items-from-a-powershell-array.html
#[System.Collections.ArrayList]$ModifyableSelectionList = $SelectionList

write-Host $Prompt

If (-not ([string]::IsNullOrEmpty($Default)))
{
    # Need to capture retrun of .Add() as it returns the number of elements
    #$numOptions = $ModifyableSelectionList.Add('Enter')
    $ValidKeys += ' ( Default ' + $Default + ' )'
}
write-Host $ValidKeys

[boolean]$first = $true
do 
{
    # Ref: https://stackoverflow.com/questions/31603128/check-if-a-string-contains-any-substring-in-an-array-in-powershell
    # Ref https://stackoverflow.com/questions/25768509/read-individual-key-presses-in-powershell
    $KeyPress = [System.Console]::ReadKey($true)
    $K = $KeyPress.Key

    #if ( $ModifyableSelectionList -notcontains $K)
    #{
    #    write-Host 'AAA'
    #    if ($first)
    #    {
    ##        write-Host '  --Invalid' -NoNewLine
     #       $first = $false
    ##    }
   #  }
    $val='Z'
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
        Enter { 
            If (-not ([string]::IsNullOrEmpty($Default)))
            {
                $val = $Default
            } 
            else{
                $val = 'Z'
            }
        }
        Default {$val = [char]$k}
    }
    if ( $SelectionList -notcontains $val)
    {
        if ($first)
        {
            write-Host '  --Invalid' -NoNewLine
            $first = $false
        }
    }
# Ref: https://www.computerperformance.co.uk/powershell/contains/
} while ( $SelectionList -notcontains $val)

if ($first -eq $false)
{
    write-Host `b`b`b`b`b`b`b -NoNewLine
    write-Host 'OK Now  ' 
}

return $val

