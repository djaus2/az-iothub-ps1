function choose-selection-redirected{
param (
    [Parameter(Mandatory)]
     [string]$ListString, 
     [string]$Title,
     [string]$CurrentSelection='None',
     [string]$Sep=',',
     [string]$AdditionalMenuOptions='B. Back',
     [int]$ItemsPerLine=1,
     $ColWidth=1
 )
 $Default = -1
 $SelectionList1 =@()
 # Ref: https://www.jonathanmedd.net/2014/01/adding-and-removing-items-from-a-powershell-array.html
 $SelectionList = {$SelectionList1}.Invoke()
 [string]$temp =  [string]$ColWidth
 $FormatStrn = '{0,-' + $temp + '}'
 

 [boolean]$includeBack= $true
 
 
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
     return  'Back'
 }  
 

 $lines =$ListString  -split $Sep[0]

 $noEntities = $lines.Length

 [int] $i=1

 write-Host ''
 $prompt = 'Select the ' + $Title
 write-Host $prompt
 write-Host ''
 $col=0
 foreach ($line in $lines) 
 {
     if ([string]::IsNullOrEmpty($line))
     {   
         write-Host ''
         $i++        
         break
     }
      
    $itemToList = $line

          

     [string]$prompt = [string]$i
     $n = $SelectionList.Add($prompt[0])  
     $prompt += '. '     
     $prompt +=  $itemToList
     $prompt = [string]::Format($FormatStrn,$prompt )
     if (($CurrentSelection -eq 'None') -or  ([string]::IsNullOrEmpty($CurrentSelection)))
     {
         write-Host $prompt 
     }
     elseif ( $itemToList -eq $CurrentSelection)
     {
         $DefaultNo = $i
         $DefaultNoStrn = [string]$i
         [string]$prompt = [string]$i
         $prompt += '. '   
         write-Host $prompt -NoNewline
         $prompt = [string]::Format($FormatStrn,$itemToList )
         write-Host $itemToList -BackgroundColor Yellow -ForegroundColor Blue -NoNewline
         write-Host ' <-- Current/Default Selection' -ForegroundColor DarkGreen 
     }
     else 
     {
         
         write-Host $prompt 
     }
     
     $i++
 }
 If (-not ([string]::IsNullOrEmpty($AdditionalMenuOptions)))
 {
     $Options = $AdditionalMenuOptions -split ','
     write-Host ''
     foreach ($option in $Options)
     {
         
         write-Host $option
         $val = -100
         switch ( $option[0] )
         {
             B {$val = -1}
             D {$val = -2}
             N {$val = -3}
             X {$val = -4}
         }
         if ($val -ne -100)
         {
             $n = $SelectionList.Add( $option[0])
         }
     }
 }
 

 $prompt ="Please make a (numerical) selection .. Or [Enter] if previous selection highlighted."
 write-Host $prompt
 $first = $true

 
 do 
 {
     # Ref: https://stackoverflow.com/questions/31603128/check-if-a-string-contains-any-substring-in-an-array-in-powershell
     # Ref https://stackoverflow.com/questions/25768509/read-individual-key-presses-in-powershell
     $input = Read-Host
     $val =' '

     If  ([string]::IsNullOrEmpty($input))
     {
         # [Enter] Press
         $val = $DefaultNoStrn
     }
     else{
         $val = ($input.ToUpper())[0]
     }

     if ( $SelectionList -notcontains $val){
         if ($first){
             write-Host '  --Invalid' -NoNewLine
             $first = $false
         }
     }
 } while ( $SelectionList -notcontains $val) 
 

 if ($first -eq $false)
 {
     write-Host `b`b`b`b`b`b`b -NoNewLine
     write-Host 'OK Now  ' 
 }
 
 $output = ''
 $selection = $val
 if ($selection -eq  'B')
 {
     $global:retVal = 'Back'
     return 'Back'
 }
 else 
 {      
    $selectedIndex = [int]::Parse($selection)
    $output  =($ListString-split ',')[$selectedIndex-1]  
 }
 write-Host ''
 $promptFinal = $Title +' "' +  $output + '" selected'
write-Host $promptFinal

$global:retVal =  $output
$global:retVal1 = 'D' + $val

$val=$null
$SelectionList = $null
$ListString = $null
 return $output
}
 
 