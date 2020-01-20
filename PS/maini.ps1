Clear-Host
write-Host '  A Z U R E  I o T  H U B    S E T U P  '  -BackgroundColor DarkMagenta -ForegroundColor White -NoNewline
write-Host ' using PowerShell'
write-Host ''
$answer = ''
[int]$current = 1
$selectionList ='1,2,3,4,5'
$itemsList ='Subscription,Groups,IoT Hubs,Devices,Done'
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
    $answer= read-Host 'Select action (number). (Default is highlighted) X To exit'

    $answer = $answer.Trim()
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
                    res-subscription
                }
            2   { 
                    $current=2
                    res-group   
                }
            3   { 
                    $current = 3
                    res-hub
                }
            4   { 
                    $current = 4
                    res-device  
                }
            5   { 
                    exit  
                }

        }
    }
    else 
    {
        $Current +=1
        Clear-Host
        write-Host '  A Z U R E  I o T  H U B    S E T U P  '  -BackgroundColor DarkMagenta -ForegroundColor White -NoNewline
        write-Host ' using PowerShell'
        write-Host ''
        $prompt = 'Incorrent entry. Select from: ' + $selectionList
        write-Host $prompt
        write-Host ''
    }
} until ($answer -eq 'DONE')