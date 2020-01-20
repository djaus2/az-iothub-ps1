Clear-Host
write-Host '  A Z U R E  I o T  H U B    S E T U P  '  -BackgroundColor DarkMagenta -ForegroundColor White -NoNewline
write-Host ' using PowerShell'
write-Host ''
$answer = ''
[int]$current = 1
$selectionList ='1,2,3,4,5'
$itemsList ='Subscription,Groups,IoT Hubs,Devices,Done'

$Subscription = $global:Subscription
$GroupName = $Global:GroupName
$HubName = $global:HubName
$DeviceName = $global:DeviceName

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