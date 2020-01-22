
param (
   [Parameter(Mandatory)]
    [string]$ListString, 
    [string]$Title,
    [int]$DisplayIndex='0', 
    [int]$CodeIndex='0',
    [int]$ItemsPerLine=1,
    [int]$ColWidth=22 ,
    [string]$CurrentSelection='None'
)
clear-host

[string]$temp =  [string]$ColWidth
$FormatStrn = '{0,-' + $temp + '}'

[boolean]$includeExit= $false
[boolean]$includeBack= $true
[boolean]$includeNew= $false
[boolean]$includeDelete= $false

$DefaultNo = -2

# These two checks not required as both parameters are mandatory
if (([string]::IsNullOrEmpty($ListString)) -or ($ListString.ToUpper() -eq '--HELP') -or ($ListString.ToUpper() -eq '-H'))
{
    $prompt = 'Usage: menu ListString Title [DisplayIndex] [CodeIndex] [ItemsPerLine] [ColWidth] [Current Selection]'
    write-Host $prompt
    write-Host ''
    $prompt = 'ListString:       Required. A string of lines (new line separated). Each line is an entitiy to be listed in the menu.'
    write-Host $prompt
    $prompt = '                  Each line is a .tsv list of entity properties'
    write-Host $prompt
    $prompt = 'Title:            Required. The entity name'
    write-Host $prompt
    $prompt = 'DisplayIndex:     Optional. Zero based index to entity property to display. (Default 0)'
    write-Host $prompt
    $prompt = 'CodeIndex:        Optional. Zero based index to entity property to to be returned. (Default 0)'
    write-Host $prompt    
    $prompt = 'ItemsPerLine:     Optional. Number of items to be displayed per line. (Default 1)'
    write-Host $prompt   
    $prompt = 'ColWidth:         Optional. Space for each item name. (Default 22)'
    write-Host $prompt   
    $prompt = 'CurrentSelection: Optional. Current selection as property displayed. (Default blank) Exiting'
    write-Host $prompt 
    write-Host ''   

    return ''
}  
if ([string]::IsNullOrEmpty($Title))
{
    $prompt = 'No Title for menu supplied. Run menu --help for usage.'
    write-Host $prompt
    return  ''
}  

$lines =$ListString  -split '\n'
$noEntities = $lines.Length -1
[int] $i=1
write-Host ''
write-Host 'Select a '  -NoNewline
write-Host $Title  -BackgroundColor DarkGreen  -ForegroundColor White
write-Host $prompt''

$col=0
foreach ($j in $lines) 
{
    if ([string]::IsNullOrEmpty($j))
    {   
        write-Host ''
        $i++        
        break
    }
    else {       
        $itemToList = ($j-split '\t')[$DisplayIndex]
    }
    [string]$prompt = [string]$i
    $prompt += '. '     
    $prompt +=  $itemToList
    $prompt = [string]::Format($FormatStrn,$prompt )
    if ($CurrentSelection -eq 'None')
    {
        write-Host $prompt -NoNewline
    

        if ($col -eq ($ItemsPerLine-1))
        {
            $col =0
            write-Host ''
        }
        else 
        {
            $Tab = [char]9
            write-Host $Tab -NoNewline
            $col++
        }
    }
    elseif ( $itemToList -eq $CurrentSelection)
    {
        $DefaultNo = $i
        write-Host ''
        [string]$prompt = [string]$i
        $prompt += '. '   
        write-Host $prompt -NoNewline
        $prompt = [string]::Format($FormatStrn,$itemToList )
        write-Host $itemToList -BackgroundColor Yellow -ForegroundColor Blue -NoNewline
        write-Host ' <-- Current Selection' -ForegroundColor DarkGreen 
        $col = 0
    }
    else 
    {
        
        write-Host $prompt -NoNewline
    

        if ($col -eq ($ItemsPerLine-1))
        {
            $col =0
            write-Host ''
        }
        else 
        {
            $Tab = [char]9
            write-Host $Tab -NoNewline
            $col++
        }
    }
    
    $i++
}
if ($includeNew)
{
    write-Host ''
    $prompt = 'N. '
    $prompt +=  'New ' + $Title
    write-Host $prompt
    
}
if ($includeExit)
{
    $prompt = 'D. '
    $prompt +=  'Delete a ' + $Title.Replace(' ', '')
    write-Host $prompt
}

if ($includeBack)
{
    $prompt = 'B. '
    $prompt +=  'Back '
    write-Host $prompt
    }
if ($includeExit)
{
    $prompt = 'X. '
    $prompt +=  'Exit '
    write-Host $prompt
}

# [int]$selection =1
$prompt ="Please make a (numerical) selection .. Or [Enter] if previous selection highlighted."

$first = $true
$SelectionList =@('1','2','3','4','-1','-2','-3')
do 
{
    # Ref: https://stackoverflow.com/questions/31603128/check-if-a-string-contains-any-substring-in-an-array-in-powershell
    # Ref https://stackoverflow.com/questions/25768509/read-individual-key-presses-in-powershell
    $KeyPress = [System.Console]::ReadKey($true)
    $K = $KeyPress.Key

    $val=-10
    switch ( $k )
    {
        # Numerical Keys 0 to 9
        'D1'  {$val = 0  }
        'D1'  {$val = 1  }
        'D2'  {$val = 2  }
        'D3'  {$val = 3  }
        'D4'  {$val = 4  }
        'D5'  {$val = 5  }
        'D6'  {$val = 6  }
        'D7'  {$val = 7  }
        'D8'  {$val = 8  }
        'D9'  {$val = 9  }
        B {$val = -1}
        D {$val = -2}
        N {$val = -3}
        Enter { 
            If (-not ([string]::IsNullOrEmpty($Default)))
            {
                $val = $DefaultNo
            } 
            else{
                $val = -11
            }
        }

    }
    if ( $SelectionList -notcontains $val){
        if ($first){
            write-Host '  --Invalid' -NoNewLine
            $first = $false
        }
    }
    $resp = [string]$val
# Ref: https://www.computerperformance.co.uk/powershell/contains/
} while ( $SelectionList -notcontains $resp)


if ($first -eq $false)
{
    write-Host `b`b`b`b`b`b`b -NoNewLine
    write-Host 'OK Now  ' 
}

$output = ''
$selection = $val
if ($selection -eq  -1)
{
    return ''
}

elseif ($selection -eq  -2)
{
    $output = 'Delete'
}
elseif ($selection -eq  -3)
{
    $output = 'New'
}
else 
{          
    $lines2 =($ListString-split '\n')[$selection-1]
    $output =  ($lines2-split '\t')[$CodeIndex]   
}
write-Host ''
$promptFinal = $Title +' "' +  $output + '" selected'
write-Host $promptFinal
$global:result3 = $output
return $output

