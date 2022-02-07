function show-quickstarts{
    param (
    [string] $Title = 'Quickstart',
    [string] $AltLocations = ''
)
    $prompt = "Select the $Title"
    write-Host $prompt

    $SelectionList1 =@()
    # Ref: https://www.jonathanmedd.net/2014/01/adding-and-removing-items-from-a-powershell-array.html
    $SelectionList = {$SelectionList1}.Invoke()

    $ScriptDirectory2 ="$ScriptDirectory\qs-apps\quickstarts\"
    $dirs = Get-ChildItem  -Directory -path $ScriptDirectory2\*\*  | select fullname|  out-string
    $dirsList= $dirs -split '\n' | Sort-Object -Descending
    $dirsPathz = @()
    $dirsPaths = {$dirsPathz}.Invoke()
    $FolderNamez = @()
    $FolderNames = {$FolderNamez}.Invoke()
    [int] $i=1
    foreach ($dpath in $dirsList)
    {
        $dpath2 = $dpath.Trim()
        If (-not ([string]::IsNullOrEmpty($dpath2)) )
        { 
            if ($dpath2 -ne 'FullName')
            {
                if ($dpath2 -ne '--------')
                {
                    $dpath3 = $dpath2.Replace($ScriptDirectory2,'')
                    $dirprops = $dpath3 -split '\\'
                    if ($dirprops.Length -gt 1)
                    {
                        if ($dirprops[0].substring(0,'dotnet'.Length) -ne 'dotnet')
                        {
                            if($dirprops[1].ToLower() -ne 'common'){
                                $dirsPaths.Add($dpath2)
                                $folder ='Quickstarts\'+ $dirprops[0] + "\" + $dirprops[1] 
                                $FolderNames.Add($folder)
                                write-Host $i. $dirprops[0] - $dirprops[1]
                                $SelectionList.Add($i)
                                $i++
                                
                            }
                        }
                    }
                }
            }
        }
    }
    $numDirs = $i-1

    $alts = $null
    If (-not([string]::IsNullOrEmpty($AltLocations)) )
    { 
        $alts = $AltLocations -split ','
        foreach ($loc in $alts)
        {
            if ($i -ne 10)
            {
            write-host $i. $loc
            $SelectionList.Add($i)
            $i++
            }
            else {
                write-host "0. $loc"
                $SelectionList.Add($i)
                $i++
            }
        }
    }


    write-host ''
    write-host B. Back
    $SelectionList.Add(-1)

    $prompt ="Please make a (numerical) selection .. Or [Enter] if previous selection highlighted."
    # $SelectionList =@('1','2','3','4','-1','-2','-3')
    write-Host $prompt
    $first = $true

    do 
    {
        # Ref: https://stackoverflow.com/questions/31603128/check-if-a-string-contains-any-substring-in-an-array-in-powershell
        # Ref https://stackoverflow.com/questions/25768509/read-individual-key-presses-in-powershell

        If  ([string]::IsNullOrEmpty($env:IsRedirected))
        {
            $KeyPress = [System.Console]::ReadKey($true)
            $K = $KeyPress.Key
            $KK = $KeyPress.KeyChar
        } else {
            $response = Read-Host
            If  ([string]::IsNullOrEmpty($response))
            {
               $k ={Enter}
            } else{   
                if ($response -match '^\d+$')  {   
                    $K= 'D'+ $response[0]
                } else{
                    $K = $response[0]
                }
            }
   
        }
    
        $val=-10
        switch ( $k )
        {
            # Numerical Keys 0 to 9
            'D0'  {$val = 10 }
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
                    5 { $Default = 4}
                    6 { $Default = 5}
                    7 { $Default = 6}
                    8 { $Default = 7}
                    9 { $Default = 8}
                    10 { $Default = 9}
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
                    6 { $Default = 7}
                    7 { $Default = 8}
                    8 { $Default = 9}
                    9 { $Default = 10}
                    10 { $Default = 10}
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

    $global:retVal2 = $val
 

    $global:retVal=  $null
    if ($val -eq -1)
    {
        $global:retVal= 'Back'
    }
    elseif ($val -eq 0)
    {
        $global:retVal= $dirsPaths[9]
        $global:retVal1= $FolderNames[9]
    }
    elseif ($val -le $numDirs)
    {
        $global:retVal= $dirsPaths[$val-1]
        $global:retVal1= $FolderNames[$val-1]
    }
    else 
    {
        $global:retVal = $alts[$val-$numDirs-1]
        $global:retVal1 = $alts[$val-$numDirs-1]
    }

}
