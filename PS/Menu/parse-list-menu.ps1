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
    [string]$CurrentSelection='None'
)

    [boolean]$includeExit= $false
    [boolean]$includeBack= $true
    [boolean]$includeNew= $false
    [boolean]$includeDelete= $false
    [boolean]$includeOther= $false


    if ( -not ([string]::IsNullOrEmpty($AdditionalMenuOptions)))
    {
        if ($AdditionalMenuOptions -like '*Back*')
        {
            $includeBack=$true
        }
        if ($AdditionalMenuOptions -like '*Exit*')
        {
            $includeExit=$true
        }
        if ($AdditionalMenuOptions -like '*New*')
        {
            $includeNew=$true
        }
        if ($AdditionalMenuOptions -like '*Delete*')
        {
            $includeDelete=$true
        }
        if ($AdditionalMenuOptions -like '*_*')
        {
            $includeOther=$true
        }
    }

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


    # Ref: http://powershell-guru.com/powershell-tip-116-remove-empty-elements-from-an-array/
    $lines= $ListString.Split("`r`n",[System.StringSplitOptions]::RemoveEmptyEntries)

    $noEntities = $lines.Count 

    if  ($noEntities -eq 1) 
    {
        $prompt1 = $itemToList = ($lines[0] -split '\t')[$DisplayIndex]
        $prompt = [string]::Format($FormatStrn,$prompt1 )
        write-host "Only one item to select: " -nonewline
        write-host " $prompt1 ". -backgroundcolor Yellow  -foregroundcolor black
        $prompt = "Do you want to select that?"
        get-yesorno $true $prompt
        $answer = $global:retVal
        if  ( $answer)
        {
            $global:retVal = $prompt1
            return $prompt1
        }
    }


    if ( ($noEntities -lt 10) -and    ([string]::IsNullOrEmpty($env:IsRedirected)))
    {
        parse-shortlist $ListString    $Title  $AdditionalMenuOptions  $DisplayIndex  $CodeIndex  $ItemsPerLine $ColWidth $CurrentSelection 
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
                
                write-Host $itemToList -BackgroundColor Yellow -ForegroundColor Blue -NoNewline
                write-Host ' <-- Previous/Default Selection [Enter]' -ForegroundColor DarkGreen
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
            $prompt +=  'New    ' + $Title
            write-Host $prompt
            
        }
        if ($includeDelete)
        {
            $prompt = 'D. '
            $prompt +=  'Delete ' + $Title
            write-Host $prompt
        }
        if ($includeExit)
        {
            $prompt = 'X. '
            $prompt +=  'Exit '
            write-Host $prompt
        }

        if ($includeBack)
        {
            write-Host 'B. Back'
        }
        if ($includeOther)
        {
            
            $others = $AdditionalMenuOptions -split ','
            $xx = $others.where{$_[0] -eq '_'}
            # $xx.foreach([string])
            foreach($option in $xx)
            {
                $prompt =  $option.Replace("_","")
                $key = $prompt.Substring(0,1)
                $SelectionList.Add($key)
                write-Host $prompt
            }
        }




        write-Host ''


        [int]$selection =1
        If ([string]::IsNullOrEmpty($CurrentSelection)){
            $prompt ="Please make enter a number (or letter) to select then press [Enter]"
        }
        else{
            $prompt ="Please make enter a number (or letter) to select then press [Enter].. Or just [Enter] for Current"
        }
        do 
        {
            [int] $selection = 0
            $answer = read-host $prompt
            [string]$ans = [string]$answer.ToUpper()
            if (([string]::IsNullOrEmpty($answer)) -AND( $CurrentSelection -ne ''))
            {
                #Flag enter pressed so use $CurrentSelection
                $selection  = -1
            }
            elseif ([string]::IsNullOrEmpty($answer)) 
            {
                $selection  = 0
            }
            elseif($answer -eq '-1')
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
                    $selection=0
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
            elseif ($SelectionList -contains $ans)
            {
                $selection = $i+10
            }
            else 
            {
                $selection = [int]$answer
            }
            $prompt = "Please make a VALID selection."
           

        } until (`
                ($selection -gt 0) -and (($selection  -le  $i+4) `
                -and ($selection  -ne  ($i)) ) `
                -or ($SelectionList -contains $ans) `
                -OR ($selection -eq -1))

        $output = ''
        # Got to update next section
        if ($SelectionList -contains $ans)
        {
            write-host "[1] Create New Group in Subscription: $Subscription then ..."
            write-host "[2] Create New Hub in Group then ..."
            write-host "[3] Create Device in Hub then ..."
            write-host "[4] Get connection strings"
            write-host "Continue?"
            get-yesorno $true
            $answer =  $global:retVal
            if ($answer)
            {
                $namesStrn = read-host Enter GroupName,HubName,DeviceName as CSV string
                write-host "Validating the CSV list"
                if ([string]::IsNullOrEmpty($namesStrn)) 
                {
                    return 'Back 1'
                }
                $names = $namesStrn -split ','
                if ($names.Length -ne 3)
                {
                    write-host $names.Length
                    return 'Back 2'
                }
                foreach ($name in $names)
                {
                    $name = $name.Trim()
                    if ([string]::IsNullOrEmpty($name)) 
                    {
                        return 'Back 3'
                    }
                }

                write-Host "Checking names against existing entities in the Subscription: $Subscription"
                if   ( check-group $Subscription $names[0]  )
                {
                    return 'Back 4'
                }
                if (check-hub  $Subscription $names[0] $names[1] )
                {
                    return 'Back 5'
                }
                If ($false)
                {
                    # Can't serach for devices without a hub
                    # 2Do Get all hubs then search those for the device name
                    if (check-device  $Subscription $names[0] $names[1] $names[2] )
                    {
                        return 'Back 6'
                    }
                }
                $grp = $names[0]
                $hb = $names[1]
                $dev =$names[2]
                write-host "[1] Create New Group $grp in Subscription: $Subscription then ..."
                write-host "[2] Create New Hub $hb in Group then ..."
                write-host "[3] Create Device $dev in Hub then ..."
                write-host "[4] Get connection strings"
                get-yesorno $true "Continue?"
                $answer = $global:retVal
                if (-not $answer)
                {
                    return 'Back'
                }

                [boolean]$success=$false
                $lev=0
                write-host "[1] Create New Group in Subscription: $Subscription"
                new-group $Subscription $grp
                if   ( check-group $Subscription $grp  )
                {
                    $lev++
                    write-host "[2] Create New Hub in Group"
                    new-hub $Subscription $grp $hb
                    if (check-hub  $Subscription $grp $hb )
                    {
                        $lev++
                        write-host "[3] Create Device in Hub"
                        new-device $Subscription $grp $hb $dev
                        if (check-device  $Subscription $grp $hb $dev )
                        {
                            $lev++
                            write-host "[4] Get connection strings."
                            get-all  $Subscription $grp $hb $dev

                            $sucess = $true
                        }
                    }
                }
                if ($sucess)
                {
                    write-host "Creation suceeded"
                }
                else {
                    write-host "Failed: $lev"
                }
                get-anykey

            }
            else{
                return 'Back'
            }
        }
        elseif ($selection -eq -1)
        {
            $output = $CurrentSelection
            $promptFinal = "Current $Title selected."
        }
        elseif ($selection -eq  $i+3)
        {
            $output = 'Back'
            $promptFinal = $output +" selected."
        }
        elseif ($selection -eq  $i+4)
        {
            $output = 'Exit'
            $promptFinal = $output +" selected."
        }
        elseif ($selection -eq  $i+2)
        {
            $output = 'Delete'
            $promptFinal = $output +" selected."
        }
        elseif ($selection -eq  $i+1)
        {
            $output = 'New'
            $promptFinal = $output +" selected."
        }
        else 
        {          
            $lines2 =($ListString-split '\n')[$selection-1]
            $output =  ($lines2-split '\t')[$CodeIndex]  
            $promptFinal = $Title +' "' +  $output + '" selected' 
        }
        write-Host ''
        
        write-Host $promptFinal
        $global:retVal = $output

    }
}

