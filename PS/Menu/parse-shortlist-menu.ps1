
function parse-shortlist{
param (
   [Parameter(Mandatory)]
    [string]$ListString, 
    [string]$Title,
    [string]$AdditionalMenuOptions='',
    [int]$DisplayIndex='0', 
    [int]$CodeIndex='0',
    [int]$ItemsPerLine=1,
    [int]$ColWidth=22 ,
    [string]$CurrentSelection='None'
)
    write-host 'Using Short Menu'    

    $baseMenu =@()
    $Selns={$baseMenu}.Invoke()
    function AddKey
    {
    param (
    [Parameter(Mandatory)]
        [int]$no
    )
        switch ($no)
        {
            0  {$Sselns.Add({D0}) }
            1  {$Selns.Add({D1}) }
            2  {$Selns.Add({D2}) }
            3  {$Selns.Add({D3}) }
            4  {$Selns.Add({D4}) }
            5  {$Selns.Add({D5}) }
            6  {$Selns.Add({D6}) }
            7  {$Selns.Add({D7}) }
            8  {$Selns.Add({D8}) }
            9  {$Selns.Add({D9}) }
        }
    }

    function AddChar
    {
    param (
    [Parameter(Mandatory)]
        [string]$ch
    )
        switch ($ch)
        {
            'B'  {$selns.Add('B') }
            'N'  {$selns.Add({'N'}) }
            'D'  {$selns.Add({'D'}) }
        }
    }

    [string]$temp =  [string]$ColWidth
    $FormatStrn = '{0,-' + $temp + '}'

    [boolean]$includeExit= $false
    [boolean]$includeBack= $true
    [boolean]$includeNew= $true
    [boolean]$includeDelete= $true


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

        $global:retVal = $null
        return
    }  
    if ([string]::IsNullOrEmpty($Title))
    {
        $prompt = 'No Title for menu supplied. Run menu --help for usage.'
        write-Host $prompt
        
        $global:retVal = $null
        return
    }  

    # Ref: http://powershell-guru.com/powershell-tip-116-remove-empty-elements-from-an-array/
    $lines= $ListString.Split("`r`n",[System.StringSplitOptions]::RemoveEmptyEntries)
    $noEntities = $lines.Count
    write-Host 'No. of entities: ' -NoNewLine
    write-Host $noEntities
    
    [int] $i=1
    write-Host ''
    $prompt = 'Select a ' + $Title
    write-Host $prompt
    write-Host ''
    $col=0
    $NumActualEntries=0
    foreach ($j in $lines) 
    {
        $line = $j.Trim()

        if ([string]::IsNullOrEmpty($line))
        {   
            $i++        
            break
        }
        else {       
            $itemToList = ($line-split '\t')[$DisplayIndex]
                $Selns.Add([string]$i)
            $NumActualEntries++
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
    write-Host ''

    If (-not ([string]::IsNullOrEmpty($AdditionalMenuOptions)))
    {
        $Options = $AdditionalMenuOptions -split ','
        write-Host ''
        foreach ($option in $Options)
        {
            write-Host $option
            $Selns.Add($option[0])
        }
    }

   
    write-Host ''

    # [int]$selection =1
    #$SelectionList | where-object {$_ } | Foreach-Object { write-Host '>>' -NoNewline;write-Host $_ 
    #}
    $prompt ="Please make a (single digit) selection .. Or just [Enter] if required selection is highlighted BELOW"
    write-Host $prompt
    # $SelectionList =@('1','2','3','4','-1','-2','-3')
    $first = $true

    # write-Host 'Valid Keys: ' -NoNewline
    # foreach ($n in $Selns) {write-Host $n -NoNewline; write-Host ' ' -NoNewline}

    $KK = ' '

    # Nb : Single item has beem handled higher up

    do 
    {

        # Ref: https://stackoverflow.com/questions/31603128/check-if-a-string-contains-any-substring-in-an-array-in-powershell
        # Ref https://stackoverflow.com/questions/25768509/read-individual-key-presses-in-powershell
        $KeyPress = [System.Console]::ReadKey($true)
        $K = $KeyPress.Key
        $KK = $KeyPress.KeyChar

        switch ( $k )
        {

            Enter { 
                if ( -not ([string]::IsNullOrEmpty($CurrentSelection)))
                {
                    $KK=[string]$DefaultNo
                }
            }
            B {

            }
            Default
            {
                if ( $Selns -notcontains $KK){
                    if ($first){
                        write-Host '  --Invalid' -NoNewLine
                        $first = $false
                    }
                }
            }
        }

        ## $resp = [string]$val
    # Ref: https://www.computerperformance.co.uk/powershell/contains/
    #} while ( $SelectionList -notcontains $val) ##  $resp)foreach 
    } while ( $Selns -notcontains $KK) 
    

    if ($first -eq $false)
    {
        write-Host `b`b`b`b`b`b`b -NoNewLine
        write-Host 'OK Now  ' 
    }

    $output = ''
    if ($KK -eq 'B')
    {
        $output = 'Back'
        $promptFinal =$output + " selected."
    }
    elseif ($KK -eq 'D')
    {
        $output = 'Delete'
        $promptFinal =$output + " selected."
    }
    elseif ($KK -eq 'S')
    {
        $output =  'Show'
        $promptFinal =$output + " selected."
    }
    elseif ($KK -eq 'N')
    {
        $output =  'New'
        $promptFinal =$output + " selected."
    }
    elseif ($KK -eq 'U')
    {
        $output =  'Unselect'
        $promptFinal =$output + " selected."
    }
    elseif ($KK -eq 'C')
    {
        $output =  'Connect'
        $promptFinal =$output + " selected."
    }
    elseif ($KK -eq 'Z')
    {
        $output =  'Disconnect'
        $promptFinal =$output + " selected."
    }
    else 
    {     
        [int]$indx =-1  
        if ( [int]::TryParse($KK,[ref] $indx))
        {
            $line =($ListString-split '\n')[$indx-1]
            $output =  ($line -split '\t')[$CodeIndex]  
            $promptFinal = $Title +' "' +  $output + '" selected' 
        }
        else
        {
            write-Host 'Error'
            $output =  'Error'
            $promptFinal =$output +" occured."
        }
    }
    write-Host ''
    
    write-Host $promptFinal
    $global:retVal= $output
}

