
function parse-shortlist{
param (
   [Parameter(Mandatory)]
    [string]$ListString, 
    [string]$Title,
    [string]$AdditionalMenuOptions='B. Back',
    [int]$DisplayIndex='0', 
    [int]$CodeIndex='0',
    [int]$ItemsPerLine=1,
    [int]$ColWidth=22 ,
    [string]$CurrentSelection='None'
)
    write-Host 'Short Menu'
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

    $lines =$ListString  -split '\n'
    $noEntities = ($lines.Count)
    
    write-Host 'No. of entities: ' -NoNewLine
    write-Host $noEntities
    
    [int] $i=1
    write-Host ''
    $prompt = 'Select a ' + $Title
    write-Host $prompt
    write-Host ''
    $col=0
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
            $Selns.Add($option[0])
        }
    }

    # [int]$selection =1
    #$SelectionList | where-object {$_ } | Foreach-Object { write-Host '>>' -NoNewline;write-Host $_ 
    #}
    $prompt ="Please make a (numerical) selection .. Or just [Enter] if required selection is highlighted."
    write-Host $prompt
    # $SelectionList =@('1','2','3','4','-1','-2','-3')
    $first = $true

    write-Host 'Valid Keys: ' -NoNewline
    foreach ($n in $Selns) {write-Host $n -NoNewline; write-Host ' ' -NoNewline}
    write-Host ''

    $KK = ' '
    do 
    {
        # Ref: https://stackoverflow.com/questions/31603128/check-if-a-string-contains-any-substring-in-an-array-in-powershell
        # Ref https://stackoverflow.com/questions/25768509/read-individual-key-presses-in-powershell
        $KeyPress = [System.Console]::ReadKey($true)
        $K = $KeyPress.Key
        $KK = $KeyPress.KeyChar

        switch ( $k )
        {

            UpArrow  { 
                switch ($Default )
                {
                    1 { $Default = 1}
                    2 { $Default = 1}
                    3 { $Default = 2}
                    4 { $Default = 3}
                    5 { $Default = 4}
                    6 { $Default = 5}
                    7 { $Default = 6}
                    8 { $Default = 7}
                    9 { $Default = 8}
                } 
            }
            DownArrow  { 
                switch ($Default )
                {
                    1 { $Default = 2}
                    2 { $Default= 3}
                    3 { $Default= 4}
                    4 { $Default= 5}
                    5 { $Default = 6}
                    6 { $Default= 7}
                    7 { $Default= 8}
                    8 { $Default= 9}
                    9 { $Default= 9}
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
    }
    elseif ($KK -eq 'D')
    {
        $output = 'Delete'
    }
    elseif ($KK -eq 'N')
    {
        $output =  'New'
    }
    else 
    {     
        [int]$indx =-1  
        if ( [int]::TryParse($KK,[ref] $indx))
        {
            write-Host $indx
            $line =($ListString-split '\n')[$indx-1]
            write-Host $CodeIndex
            Write-Host $line
            $output =  ($line -split '\t')[$CodeIndex]   
        }
        else
        {
            write-Host 'Error'
            $output =  'Error'
        }
    }
    write-Host ''
    $promptFinal = $Title +' "' +  $output + '" selected'
    write-Host $promptFinal
    $global:retVal= $output
}

