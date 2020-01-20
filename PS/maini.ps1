Clear-Host
write-Host '  A Z U R E  I o T  H U B    S E T U P  '  -BackgroundColor DarkMagenta -ForegroundColor White -NoNewline
write-Host ' using PowerShell'
write-Host ''
$answer = ''
[int]$current = 1
$selectionList ='1,2,3,4,5'

# $selections = $selectionList -split ','
$itemsList ='Subscription,Groups,IoT Hubs,Devices,Done'

$Subscription = $global:Subscription
$GroupName = $Global:GroupName
$HubName = $global:HubName
$DeviceName = $global:DeviceName
[boolean] $GetKey = $true
do
{

    write-Host ''
    $items =$ItemsList  -split ','
    $i=1
    foreach ($item in $items) 
    {
        [string]$prompt = [string]$i
        $prompt += '. '  
        write-Host $prompt  -NoNewline
        $prompt =  $item

        if ($Current -eq 0)
        {
            write-Host $prompt 
        }
        elseif ( $Current -eq $i)
        {
            write-Host $prompt -BackgroundColor Yellow -ForegroundColor Blue -NoNewline
            write-Host ' <-- Current Selection' -ForegroundColor DarkGreen 
        }
        else 
        {            
            write-Host $prompt
        }
        $i++
    }
    write-Host X. Exit
    # $answer= read-Host 'Select action (number). (Default is highlighted) X To exit'
    
    if ($GetKey -eq $true)
    {
        do 
        {
            # Ref: https://stackoverflow.com/questions/31603128/check-if-a-string-contains-any-substring-in-an-array-in-powershell
            $KeyPress = [System.Console]::ReadKey()
            $K = $KeyPress.Key
        } while ( -not ( ($K -eq 'D1') -or ($K -eq 'D2') -or ($K -eq 'D3')   -or ($K -eq 'D4') -or ($K -eq 'D5') `
        -or ($K -eq 'X')  -or ($K -eq 'UpArrow') -or ($K -eq 'DownArrow') -or ($K -eq 'Enter') ))
    }
    $GetKey = $true
    switch ( $k )
        {
            'D1'   { 
                    $current=1
                    $Subscription = res-subscription $Subscription
                    $current=2
                }
            'D2'   { 
                    $current=2
                    $GroupName = res-group   $Subscription $GroupName
                    $current=3
                }
            'D3'   { 
                    $current = 3
                    $HubName = res-hub $Subscription $GroupName $HubName
                    $current = 4
                }
            'D4'  { 
                    $current = 4
                    $DeviceName = res-device  $Subscription $GroupName $HubName $DeviceName
                }
            'D5'   { 
                    exit  
                }
            X   { 
                    exit  
                }
            
            UpArrow  { 
                switch ($current )
                {
                    0 { $current = 0}
                    1 { $current = 1}
                    2 { $current = 1}
                    3 { $current = 2}
                    4 { $current = 3}
                    5 { $current = 4}
                } 
            }
            DownArrow  { 
                switch ($current )
                {
                    0 { $current = 1}
                    1 { $current = 2}
                    2 { $current = 3}
                    3 { $current = 4}
                    4 { $current = 5}
                } 
            }
            Enter {
                $GetKey = $true
                switch ($current )
                {
                    1 { $K = 'D1'
                    $GetKey = $false}
                    2 { $K = 'D2'
                    $GetKey = $false}
                    3 { $K = 'D3'
                    $GetKey = $false}
                    4 { $K = 'D4'
                    $GetKey = $false}
                } 
            }
        }
 
        Clear-Host
        write-Host '  A Z U R E  I o T  H U B    S E T U P  '  -BackgroundColor DarkMagenta -ForegroundColor White -NoNewline
        write-Host ' using PowerShell'
        write-Host ''
      
            continue
    # $answer = $answer.Replace(':','')
    # $answer = $answer.Trim()
    # write-Host ''
    # read-host $answer

    # exit

    if ([string]::IsNullOrEmpty($answer))
    {
        $answer =[string]$Current
    }
    if($answer -eq 'X')
    {
        $answer = 'DONE'
        exit
    }
    $answer = $answer.ToUpper()
    if (($answer | %{$selectionList.contains($_)}) -contains $true)
    {
        switch ( $answer )
        {
            1   { 
                    $current=1
                    $Subscription = res-subscription $Subscription
                    $current=2
                }
            2   { 
                    $current=2
                    $GroupName = res-group   $Subscription $GroupName
                    $current=3
                }
            3   { 
                    $current = 3
                    $HubName = res-hub $Subscription $GroupName $HubName
                    $current = 4
                }
            4   { 
                    $current = 4
                    $DeviceName = res-device  $Subscription $GroupName $HubName $DeviceName
                }
            5   { 
                    exit  
                }

        }
        Clear-Host
        write-Host '  A Z U R E  I o T  H U B    S E T U P  '  -BackgroundColor DarkMagenta -ForegroundColor White -NoNewline
        write-Host ' using PowerShell'
        write-Host ''
    }
    else 
    {
        Clear-Host
        write-Host '  A Z U R E  I o T  H U B    S E T U P  '  -BackgroundColor DarkMagenta -ForegroundColor White -NoNewline
        write-Host ' using PowerShell'
        write-Host ''
        $prompt = 'Incorrent entry. Select from: ' + $selectionList
        write-Host $prompt
        write-Host ''
    }
} until ($answer -eq 'DONE')