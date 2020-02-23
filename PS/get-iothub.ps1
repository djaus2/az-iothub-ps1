# region Include required files
#
$global:ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
write-Host $global:ScriptDirectory
try {
    . ("$global:ScriptDirectory\menu\qs.ps1")
    . ("$global:ScriptDirectory\util\settings.ps1")
    . ("$global:ScriptDirectory\resources\environ-varsmenu.ps1")

    . ("$global:ScriptDirectory\menu\any-key-menu.ps1")
    . ("$global:ScriptDirectory\menu\yes-no-menu.ps1")
    . ("$global:ScriptDirectory\menu\parse-list-menu.ps1")
    . ("$global:ScriptDirectory\menu\parse-shortlist-menu.ps1")
    . ("$global:ScriptDirectory\menu\choose-selection-menu.ps1")
    . ("$global:ScriptDirectory\menu\choose-selection-menu-redirected.ps1")


    . ("$global:ScriptDirectory\resources\res-subscription.ps1")
    . ("$global:ScriptDirectory\resources\res-group.ps1")
    . ("$global:ScriptDirectory\resources\res-hub.ps1")
    . ("$global:ScriptDirectory\resources\res-device.ps1")
    . ("$global:ScriptDirectory\resources\run-quickstarts.ps1")
    . ("$global:ScriptDirectory\resources\clr-quickstarts.ps1")
    . ("$global:ScriptDirectory\resources\manage-appdata.ps1")


    . ("$global:ScriptDirectory\new_delete\new-group.ps1")
     . ("$global:ScriptDirectory\new_delete\new-hub.ps1")
    . ("$global:ScriptDirectory\new_delete\new-device.ps1")

    . ("$global:ScriptDirectory\new_delete\delete-group.ps1")
    . ("$global:ScriptDirectory\new_delete\delete-hub.ps1")
     . ("$global:ScriptDirectory\new_delete\delete-device.ps1")
     . ("$global:ScriptDirectory\resources\show-splashscreen.ps1")
}
catch {
    Write-Host "Error while loading supporting PowerShell Scripts" 
    Write-Host $_
}

#endregion

Show-Splashscreen





If  (-not([string]::IsNullOrEmpty($env:IsRedirected)))
{
    Clear-Host
    write-Host ''
    write-Host ''
    write-Host ''
    write-Host ''
    write-Host ''
    write-Host ''
    write-Host "Note that because redirection is inplay, menu selections [1,2,3...X,B etc] require [Enter] afterwards."
    read-Host "Please press [Enter] to continue."

}


if (Test-Path "$global:ScriptDirectory\app-settings.ps1")
{
    & "$global:ScriptDirectory\app-settings"
}

if (Test-Path "$global:ScriptDirectory\set-env.ps1")
{
    & "$global:ScriptDirectory\set-env"
}



util\heading  -Prompt '  S E T U P  ' -BG DarkMagenta  -FG White
$answer = ''
[int]$current = 1
$selectionList =@('D1','D2','D3','D4','D5','D6','D7','D8','UpArrow','DownArrow','Enter','X','R')

# $selections = $selectionList -split ','
$itemsList ='Subscription,Groups,IoT Hubs,Devices,Environment Variables,Quickstart Apps,Manage App Data,Done'

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
    $Prompt = '   Subscription :"' + $Subscription +'"'
    write-Host $Prompt
    $Prompt = '          Group :"' + $GroupName +'"'
    write-Host $Prompt
    $Prompt = '            Hub :"' + $HubName +'"'
    write-Host $Prompt
    $Prompt = '         Device :"' + $DeviceName +'"'
    write-Host $Prompt
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
        If  ([string]::IsNullOrEmpty($env:IsRedirected))
        {
            $KeyPress = [System.Console]::ReadKey($true)
            $K = $KeyPress.Key
        } else {
            $response = Read-Host
            If  ([string]::IsNullOrEmpty($response))
            {
                $k ={Enter}
            } else{   
                if ($response -match '^\d+$')   
                {       
                $K= 'D'+ $response[0]
                } else{
                    $K = $response[0]
                }
            }

        }
    }
    $GetKey = $true
    if  ( $selectionList -contains $K)
    {
        switch ( $k )
        {
            'D1'   { 
                    $current=1
                    
                    Get-Subscription $Subscription
                    $response = $global:retVal
                    # read-Host $response
                    
                    if ( ([string]::IsNullOrEmpty($response)) )
                    {

                    }
                   elseif ($response -eq 'Back')
                   {

                   }
                   elseif ($response -eq 'Exit')
                   {
                        Exit
                   }
                   elseif ($response -eq 'Error')
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
                    Get-Group   $Subscription $GroupName
                    $response = $global:retVal
                    if (([string]::IsNullOrEmpty($response)) )
                    {

                    }
                    elseif ($response -eq 'New')
                    {
                        #. ("$global:ScriptDirectory\new_delete\new-group.ps1")
                        New-Group  $Subscription 
                    }
                    elseif ($response -eq 'Delete')
                    {
                        If([string]::IsNullOrEmpty($GroupName )) 
                        {
                            Remove-group  $Subscription ''
                        }
                        else {
                            Remove-group  $Subscription $GroupName
                        }
                        
                    }
                    elseif ($response -eq 'Back')
                    {

                    }
                    elseif ($response -eq 'Exit')
                    {
                        exit
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
                    Get-Hub $Subscription $GroupName $HubName
                    $response = $global:retVal
                    # read-Host $response
                    if (([string]::IsNullOrEmpty($response)) )
                    {

                    }
                    elseif ($response -eq 'New')
                    {
                        new-Hub $Subscription $GroupName 
                    }
                    elseif ($response -eq 'Delete')
                    {                    
                        If([string]::IsNullOrEmpty($HubName )) 
                        {
                            Remove-Hub  $Subscription $GroupName
                        }
                        else {
                            Remove-Hub  $Subscription $GroupName $HubName
                        }
                    }
                    elseif ($response -eq 'Back')
                    {
 
                    }
                    elseif ($response -eq 'Exit')
                    {
                        exit
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
                    Get-Device  $Subscription $GroupName $HubName $DeviceName
                    $response = $global:retVal
                    # read-Host $response
                    if ( ([string]::IsNullOrEmpty($response)) )
                    {
                        $DeviceName = $null
                    }
                    elseif ($response -eq 'New')
                    {
                        New-Device $Subscription $GroupName $HubName 
                    }
                    elseif ($response -eq 'Delete')
                    {                       
                        If([string]::IsNullOrEmpty($DeviceName )) 
                        {
                            Remove-Device  $Subscription $GroupName $HubName
                        }
                        else {
                            Remove-Device  $Subscription $GroupName $HubName $DeviceName
                        }
                    }
                    elseif ($response -eq 'Back')
                    {

                    }
                    elseif ($response -eq 'Exit')
                    {
                        exit
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
            'D5' { Do-Envs $Subscription $GroupName $HubName $DeviceName }
            'D6' { $response = Run-Apps $Subscription $GroupName $HubName $DeviceName
                    if ($response -ne 'Back')
                    {
                        exit
                    }
                }
            'D7' { Manage-AppData}

            'D8' {exit}
            R    { 
                    util\heading  -Prompt '  C L E A R   G L O B A L  V A L U E S  ' -BG DarkRed  -FG White
                    get-yesorno $false 'Clear script globals variables? [Yes] [No]'
                    $answer = $global:retVal
                    if ($answer)
                    {
                        
                        $global:DoneLogin = $null
                        $global:DontClearOnHeading = $null

                        $global:SubscriptionStrn = $null
                        $global:GroupsStrn =$null
                        $global:HubsStrn=$null
                        $global:DevicesStrn=$null

                        $global:Subscription = $null
                        $global:GroupName = $null
                        $global:HubName= $null
                        $global:DeviceName=$null

                        $global:Locations = $null

                        $global:Urls =$null
                        
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
                    5 { $current = 4}
                    6 { $current = 5}
                    7 { $current = 6}
                } 
            }
            DownArrow  { 
                switch ($current )
                {
                    1 { $current = 2}
                    2 { $current = 3}
                    3 { $current = 4}
                    4 { $current = 5}
                    5 { $current = 6}
                    6 { $current = 7}
                    7 { $current = 7}
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
                    5 { $K = 'D5'
                    $GetKey = $false}
                    6 { $K = 'D6'
                    $GetKey = $false}
                    7 { $K = 'D7'
                    $GetKey = $false}
                    Default { $GetKey = $true }
                } 
            }
        }
    }
    util\heading  -Prompt '  S E T U P  ' -BG DarkMagenta  -FG White
  
} until ($false)