function parse-list{
param (
   [Parameter(Mandatory)]
    [string]$ListString, 
    [string]$Title='Menu List',
    [string]$AdditionalMenuOptions='',
    [int]$DisplayIndex='0', 
    [int]$CodeIndex='0',
    [int]$ItemsPerLine=1,
    [int]$ColWidth=22 ,
    [string]$CurrentSelection='None',
    [bool]$HandBack=$false
)

    if ($CurrentSelection -eq $null)
    {
        $CurrentSelection =''
    }

    [boolean]$includeExit= $false
    [boolean]$includeBack= $true
    [boolean]$includeNew= $false
    [boolean]$includeDelete= $false
    [boolean]$includeOther= $false




    [string]$temp =  [string]$ColWidth
    $FormatStrn = '{0,-' + $temp + '}'

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

    $noEntities =0
    if($ListString -ne 'EMPTY' ){
        # Ref: http://powershell-guru.com/powershell-tip-116-remove-empty-elements-from-an-array/
        $lines= $ListString.Split("`r`n",[System.StringSplitOptions]::RemoveEmptyEntries)

        $noEntities = $lines.Count 

        $global:doneItem=$false


        if  ($noEntities -eq 1) 
        {
            $prompt1 = $itemToList = ($lines[0] -split '\t')[$DisplayIndex]
            if ($prompt1 -ne  $CurrentSelection)
            {
                write-host ''
                $prompt = [string]::Format($FormatStrn,$prompt1 )
                write-host "Only one item to select: " -nonewline
                write-host " $prompt1 ". -backgroundcolor Yellow  -foregroundcolor black

                $alternatives= 'Select that instance and return,Select that instance and stay here,Ignore it'


                $answer = choose-selection $alternatives $Title 'Select that instance and return'
                switch ($answer){
                    'Select that instance and return'{
                        # If have made "new" selection then return
                        # It should then come back here (re-call this funstion) with updated menu options.
                        $CurrentSelection = $prompt1
                        $global:retVal = $CurrentSelection
                        # Tell the current item to return to the main menu
                        $global:doneItem=$true
                        return  $CurrentSelection
                    }
                    'Select that instance and stay here'{
                        # If have made "new" selection then return
                        # It should then come back here (re-call this funstion) with updated menu options.
                        $CurrentSelection = $prompt1
                        $global:retVal = $CurrentSelection 
                        $global:doneItem=$false
                        return  $CurrentSelection
                    }
                    'Ignore it'{}
                    'Back' {
                        $global:retVal='Back'
                        return
                    }                
                }
            }
            
        }
    }

    if ( ($noEntities -lt 10) -and    ([string]::IsNullOrEmpty($env:IsRedirected)))
    {
        parse-shortlist $ListString    $Title  $AdditionalMenuOptions  $DisplayIndex  $CodeIndex  $ItemsPerLine $ColWidth $CurrentSelection  $HandBack
        return $global:retVal
    }
    else 
    {

        write-Host "Using Long Menu"
        [int] $i=1
        write-Host ''
        write-Host 'Select a '  -NoNewline
        write-Host $Title 
        write-Host $prompt''
        $DefaultNo = -1

        $SelectionList1 =@()
        # Ref: https://www.jonathanmedd.net/2014/01/adding-and-removing-items-from-a-powershell-array.html
        $SelectionList = {$SelectionList1}.Invoke()

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
                $SelectionList.Add($i)
            }
            [string]$prompt = [string]$i
            $prompt += '. '     
            $prompt +=  $itemToList
            $prompt = [string]::Format($FormatStrn,$prompt )
            If  ([string]::IsNullOrEmpty($CurrentSelection))
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
                
                write-Host $itemToList  -ForegroundColor Yellow -NoNewline
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
        write-host ''
        If (-not ([string]::IsNullOrEmpty($AdditionalMenuOptions)))
        {
            write-host ''
            $Options = $AdditionalMenuOptions -split ','
            write-Host ''
            foreach ($option in $Options)
            {
                write-Host $option
                [char] $ch = [char] ($option.ToUpper()).Substring(0,1)
                [int]$opcode = 128 + [int] $ch
                $SelectionList.Add($opcode)
            }
        }
        $SelectionList.Add(-1)

        write-Host ''

        



        do{
	        if ([string]::IsNullOrEmpty($CurrentSelection)){
                $prompt ="Please make enter a number (or letter) to select then press [Enter]"
            }
            else{
                $prompt ="Please make enter a number (or letter) to select then press [Enter].. Or just [Enter] for Current"
            }
	        [int] $selection = 0
            $answer = read-host $prompt
            $answer = $answer.ToUpper()

            if($answer -match '^\d+$')
            {
                # All OK, is an integer
                $Selection = [int]$answer
                
            }
            elseif (([string]::IsNullOrEmpty($answer)) -AND( $CurrentSelection -ne ''))
            {
                #Flag enter pressed so use $CurrentSelection and return
                $selection  = -1
            }
            elseif ([string]::IsNullOrEmpty($answer)) 
            {
                $selection  = 0
            }
            else{
                [char] $ch = [char] ($answer.ToUpper()).Substring(0,1)
                $selection = 128 + [int] $ch
            }
        
            $prompt = "Please make a VALID selection."

        } until  ($SelectionList -contains $Selection) 

        $output = ''

        if ($Selection -gt 128)
        {
            $opcode = $Selection -128
            $ch = [char] $opcode
            if ($ch -eq  'B')
            {
                $output = 'Back'
                $promptFinal = $output +" selected."
            }
            elseif ($ch -eq  'X')
            {
                $output = 'Exit'
                $promptFinal = $output +" selected."
            }
            elseif ($ch -eq  'D')
            {
                $output = 'Delete'
                $promptFinal = $output +" selected."
            }
            elseif ($ch -eq 'N')
            {
                $output = 'New'
                $promptFinal = $output +" selected."
            }
            elseif ($ch -eq  'R')
            {
                $output = 'Refresh'
                $promptFinal = $output +" selected."
            }
            elseif ($ch -eq 'U')
            {
                $output = 'Unselect'
                $promptFinal = $output +" selected."
            } 
        }
        elseif ($Selection -eq -1)  {
            $output = $CurrentSelection
            $promptFinal = "Current $Title selected."
            $output = $CurrentSelection
        } else {
            $lines2 =($ListString-split '\n')[$selection-1]
            $output =  ($lines2-split '\t')[$CodeIndex]  
            $promptFinal = $Title +' "' +  $output + '" selected'
        }

    }
    write-Host $promptFinal
    $global:retVal = $output 
    
    if ($global:recording)
    {
        start-sleep $global:recordingTime
    }
    return $output
}

