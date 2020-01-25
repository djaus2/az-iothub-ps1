util\heading  -Prompt '  S E T U P  ' -BG Blue   -FG White

$answer = ''
[int]$current = 1
$selectionList =@('D1','D2','D3','D4','D5','D6','UpArrow','DownArrow','Enter','X','R')

# $selections = $selectionList -split ','
$itemsList ='Subscription,Groups,IoT Hubs,Devices,Generate Environment Variables,Done'

$Subscription = $global:Subscription
$GroupName = $Global:GroupName
$HubName = $global:HubName
$DeviceName = $global:DeviceName
[boolean] $GetKey = $true
do
{
    $Subscription = $global:Subscription
    $GroupName = $Global:GroupName
    $HubName = $global:HubName
    $DeviceName = $global:DeviceName
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

    write-Host ''
    write-Host R. 'Reset script globals'
    write-Host X. 'Exit'
    
    write-Host 'Select action (number). (Default is highlighted) X To exit'
    
    if ($GetKey -eq $true)
    {
        $KeyPress = [System.Console]::ReadKey($true)
        $K = $KeyPress.Key
    }
    $GetKey = $true
    if  ( $selectionList -contains $K)
    {
        switch ( $k )
        {
            'D1'   { 
                    $current=1
                    
                    $response = res-subscription $Subscription
                    
                    if (-not ([string]::IsNullOrEmpty($response)) )
                    {

                    }
                   elseif ($response -eq 'Back')
                   {

                   }
                   elseif ($response -eq 'Exit')
                   {
                        Exit
                   }
                   else
                   {
                    $Subscription = $response
                   }

                   

                    $Current++
                }
            'D2'   { 
                    $current=2
                    $response= res-group   $Subscription $GroupName
                    if (-not ([string]::IsNullOrEmpty($response)) )
                    {

                    }
                    elseif ($response -eq 'New')
                    {
                        new-Group $Subscription $Group
                    }
                    elseif ($response -eq 'Delete')
                    {
                        delete-group  $Subscription $Group 
                    }
                    elseif ($response -eq 'Back')
                    {

                    }
                    elseif ($response -eq 'Error')
                    {
                        exit
                    }  
                    else
                    {
                        $GroupName = $response
                    }
                    $Current++
                }           
            'D3'   { 
                    $current = 3
                  
                    $response = res-hub $Subscription $GroupName $HubName
                    if (-not ([string]::IsNullOrEmpty($response)) )
                    {

                    }
                    elseif ($response -eq 'New')
                    {
                        new-Hub $Subscription $Group $HubName
                    }
                    elseif ($response -eq 'Delete')
                    {
                        delete-Hub  $Subscription $Group $HubName
                    }
                    elseif ($response -eq 'Back')
                    {
 
                    }
                    elseif ($response -eq 'Error')
                    {
                        exit
                    }
                    else {
                        $HubName = $response
                    }

                    $current++
                }
            'D4'  { 
                    $current = 4
                    $response= res-device  $Subscription $GroupName $HubName $DeviceName
                    if (-not ([string]::IsNullOrEmpty($response)) )
                    {
                        
                    }
                    elseif ($response -eq 'New')
                    {
                        new-Device $Subscription $Group $HubName $DeviceName
                    }
                    elseif ($response -eq 'Delete')
                    {
                        delete-Device  $Subscription $Group $HubName  $DeviceName
                    }
                    elseif ($response -eq 'Back')
                    {

                    }
                    elseif ($response -eq 'Error')
                    {
                        exit
                    }
                    else
                    {
                        $DeviceName = $response
                    }
                }
            'D5'    {   }
            'D6'    { exit  }
            R    { 
                    Clear-Host
                    write-Host ''
                    $answer = util\yes-no-menu 'Clear script globals variables? ' 'N'
                    if ($answer = 'Y')
                    {
                        
                        $global:DoneLogin = $null
                        $global:Subscription = $null
                        $global:SubscriptionStrn = $null
                        $global:GroupsStrn =$null
                        $global:HubsStrn=$null
                        $global:DevicesStrn=$null
                        $global:Group = $null
                        $global:Hub = $null
                        $global:Device=$null
                        $global:Locations = $null
                        $Subscription = $global:Subscription
                        $GroupName = $Global:GroupName
                        $HubName = $global:HubName
                        $DeviceName = $global:DeviceName
                        [boolean] $GetKey = $true
                        $Current=1
                    }
                }

            X       {  exit }
            
            UpArrow  { 
                switch ($current )
                {
                    1 { $current = 1}
                    2 { $current = 1}
                    3 { $current = 2}
                    4 { $current = 3}
                } 
            }
            DownArrow  { 
                switch ($current )
                {
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
    util\heading  -Prompt '  S E T U P  ' -BG Blue   -FG White
  
} until ($false)