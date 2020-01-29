function choose-selection{
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
     else {       
         $itemToList = $line
        # Ref: https://stackoverflow.com/questions/25322636/powershell-convert-string-to-number
        #[string]$num = [convert]::ToString($i)
        #$n = $SelectionList.Add($num[0])
        $n = $SelectionList.Add($i)        
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
         write-Host ' <-- Current/Default Selection' -ForegroundColor DarkGreen 
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
             $n = $SelectionList.Add($val)
         }
     }
 }
 
 # [int]$selection =1
  #$SelectionList | where-object {$_ } | Foreach-Object { write-Host '>>' -NoNewline;write-Host $_ 
 #}
 $prompt ="Please make a (numerical) selection .. Or [Enter] if previous selection highlighted."
 # $SelectionList =@('1','2','3','4','-1','-2','-3')
 write-Host $prompt
 $first = $true
 
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
         X {$val = -4}
         UpArrow  { 
             switch ($Default )
             {
                 1 { $Default = 1}
                 2 { $Default = 1}
                 3 { $Default = 2}
                 4 { $Default = 3}
             } 
         }
         DownArrow  { 
             switch ($Default )
             {
                 1 { $Default = 2}
                 2 { $Default= 3}
                 3 { $Default= 4}
                 4 { $Default= 5}
             } 
         }
         Enter { 
             If (-not ([string]::IsNullOrEmpty($CurrentSelection)))
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
     ## $resp = [string]$val
 # Ref: https://www.computerperformance.co.uk/powershell/contains/
 } while ( $SelectionList -notcontains $val) ##  $resp)
 
 
 if ($first -eq $false)
 {
     write-Host `b`b`b`b`b`b`b -NoNewLine
     write-Host 'OK Now  ' 
 }
 
 $output = ''
 $selection = $val
 if ($selection -eq  -1)
 {
     $global:retVal = 'Back'
     return 'Back'
 }
 else 
 {          
    $output  =($ListString-split ',')[$selection-1]  
 }
 write-Host ''
 $promptFinal = $Title +' "' +  $output + '" selected'
write-Host $promptFinal

$val=$null
$SelectionList = $null
$ListString = $null
 
$global:retVal =  $output

 return $output
}
 
 