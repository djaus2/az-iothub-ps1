
param (
   # [Parameter(Mandatory)]
    [string]$ListString, 
   # [Parameter(Mandatory)]
    [string]$Title,
    [int]$DisplayIndex='0', 
    [int]$CodeIndex='0',
    [int]$ItemsPerLine=1,
    [string]$CurrentSelection='None'
)
cls

[boolean]$includeExit= $true
[boolean]$includeBack= $true
[boolean]$includeNew= $true
[boolean]$includeDelete= $true
# These two checks not required as both parameters are mandatory
if (([string]::IsNullOrEmpty($ListString)) -or ($ListString.ToUpper() -eq '--HELP') -or ($ListString.ToUpper() -eq '-H'))
{
    $prompt = 'Usage: menu ListString Title [DisplayIndex] [CodeIndex] [ItemsPerLine] [Current Selection]'
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
$lines.Length
[int] $i=1
write-Host ''
$prompt ='Select a ' + $Title
write-Host $prompt

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
    $prompt = [string]::Format("{0,-24}",$prompt )
    if ( $itemToList -eq $CurrentSelection)
    {
        write-Host ''
        [string]$prompt = [string]$i
        $prompt += '. '   
        write-Host $prompt -NoNewline
        $prompt = [string]::Format("{0,-22}",$itemToList )
        write-Host $itemToList -BackgroundColor Yellow -ForegroundColor Blue -NoNewline
        write-Host ' <-- Current Selection' -ForegroundColor DarkGreen 
        $col = 0
    }
    else 
    {
        
        write-Host $prompt -NoNewline
    

        if ($col -eq 3)
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
if ($includeNew
{
    write-Host ''
    $prompt = 'N. '
    $prompt +=  'New ' + $Title
    write-Host $prompt
    }
if ($includeExit)
{
    [string]$prompt = [string]$i
    $prompt += 'D. '
    $prompt +=  'Delete ' + $Title
    write-Host $prompt
}

if ($includeBack)
{
    write-Host ''
    $prompt = 'B. '
    $prompt +=  'Back '
    write-Host $prompt
    }
if ($includeExit)
{
    [string]$prompt = [string]$i
    $prompt += 'X. '
    $prompt +=  'Exit '
    write-Host $prompt
}

[int]$selection =1
$prompt ="Please make a (numerical) selection .. Or [Enter] if previous selection highlighted."
do 
{
    [int] $selection = 0
    $answer = read-host $prompt
    if($answer -eq '-1')
    {
        # Just in case the user enters -1!
        $selection = 0
    }
    elseif ($answer.ToUpper() -eq 'X')
    {
        if ($includeExit){
            $selection = $i+4
        }
        else {
            $selection=o
        }
    }
    elseif ($answer.ToUpper() -eq 'B')
    {
        if ($includeBack){
            $selection = $i+3
        }
        else {
            $selection=o
        }
    }
    elseif ($answer.ToUpper() -eq 'D')
    {
        if ($includeDelete){
            $selection = $i+2
        }
        else {
            $selection=o
        }
    }
    elseif ($answer.ToUpper() -eq 'N')
    {
        if ($includeNew){
            $selection = $i+1
        }
        else {
            $selection=o
        }
    }
    elseif (([string]::IsNullOrEmpty($answer)) -AND( $CurrentSelection -ne ''))
    {
        #Flag enter pressed so use $CurrentSelection
        $selection  = -1
    }
    elseif ([string]::IsNullOrEmpty($answer)) 
    {
        $selection  = 0
    }
    else 
    {
        $selection = [int]$answer
    }
    $prompt = "Please make a VALID selection."

} until (`
        ($selection -gt 0) -and (($selection  -le  $i+4) `
        -and ($selection  -ne  ($i)) ) `
        -OR ($selection -eq -1))

$output = ''
if ($selection -eq -1)
{
    $output = $CurrentSelection
}
elseif ($selection -eq  $i+3)
{
    $output = 'Back'
}
elseif ($selection -eq  $i+4)
{
    $output = 'Exit'
}
elseif ($selection -eq  $i+2)
{
    $output = 'Delete'
}
elseif ($selection -eq  $i+1)
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

