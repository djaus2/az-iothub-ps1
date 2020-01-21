Clear-Host
write-Host '  A Z U R E  I o T  H U B    S E T U P  '  -BackgroundColor DarkMagenta -ForegroundColor White -NoNewline
write-Host ' using PowerShell AND Azure CLI'
write-Host ''
$answer = ''
[int]$current = 1
$selectionList =@('D1','D2','D3','D4','D5','UpArrow','DownArrow','Enter','X')

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
    write-Host 'Select action (number). (Default is highlighted) X To exit'
    
    if ($GetKey -eq $true)
    {
        $KeyPress = [System.Console]::ReadKey($false)
        $K = $KeyPress.Key
    }
    $GetKey = $true
    if  ( $selectionList -contains $K)
    {
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
            'D5'    { exit  }

            X       {  exit }
            
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
                # $GetKey = $true
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
                    Default { $GetKey = $true }
                } 
            }
        }
    }
        Clear-Host
        write-Host '  A Z U R E  I o T  H U B    S E T U P  '  -BackgroundColor DarkMagenta -ForegroundColor White -NoNewline
        write-Host ' using PowerShell AND Azure CLI'
        write-Host ''
    
      
    } until ($false)