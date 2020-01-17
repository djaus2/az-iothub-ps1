
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



write-Host ''
[string]$prompt = [string]$i
$prompt += '. '
$prompt +=  'Back '
write-Host $prompt
$i++
[string]$prompt = [string]$i
$prompt += '. '
$prompt +=  'Exit '
write-Host $prompt

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
        ($selection -gt 0) -and (($selection  -le  $i) `
        -and ($selection  -ne  ($i -4)) ) `
        -OR ($selection -eq -1))

$output = ''
if ($selection -eq -1)
{
    $output = $CurrentSelection
}
elseif ($selection -eq  $i-1)
{
    $output = 'Back'
}
elseif ($selection -eq  $i)
{
    $output = 'Exit'
}
else 
{          
    $lines2 =($ListString-split '\n')[$selection-1]
    $output =  ($lines2-split '\t')[$CodeIndex]   
}
write-Host ''
$promptFinal = 'Location "' +  $output + '" selected'
write-Host $promptFinal
$global:result3 = $output
return $output

