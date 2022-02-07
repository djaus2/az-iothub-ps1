# region Include required files
#
$global:ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

if ([string]::IsNullOrEmpty($global:skipLoginCheck)){
    If ([string]::IsNullOrEmpty($global:Subscription)) {
        $sub = az account show -o tsv | out-string
        If (-not ([string]::IsNullOrEmpty($sub))) {
            $Current =  (($sub -split '\t')[5]).Trim()
            $global:Subscription = $Current
        }
    }
}

try {
    . ("$global:ScriptDirectory\menu\qs.ps1")
    . ("$global:ScriptDirectory\util\settings.ps1")
    . ("$global:ScriptDirectory\resources\environ-varsmenu.ps1")
    . ("$global:ScriptDirectory\util\get-name.ps1")
    . ("$global:ScriptDirectory\util\show-heading.ps1")
    #  Not used: . ("$global:ScriptDirectory\util\check-subscription.ps1")

    . ("$global:ScriptDirectory\util\doall.ps1")


    . ("$global:ScriptDirectory\Util\Check-Group.ps1")
    . ("$global:ScriptDirectory\Util\Check-Hub.ps1")
    . ("$global:ScriptDirectory\Util\Check-Device.ps1")
    . ("$global:ScriptDirectory\Util\Check-DPS.ps1")
    . ("$global:ScriptDirectory\Util\get-location.ps1")
    . ("$global:ScriptDirectory\Util\get-SKU.ps1")
    . ("$global:ScriptDirectory\Util\show-time.ps1")
    . ("$global:ScriptDirectory\Util\set-envvar.ps1")
    . ("$global:ScriptDirectory\util\write-json.ps1")
    . ("$global:ScriptDirectory\util\write-env.ps1")
    . ("$global:ScriptDirectory\util\set-export.ps1")
    . ("$global:ScriptDirectory\util\write-export.ps1")


    . ("$global:ScriptDirectory\menu\any-key-menu.ps1")
    . ("$global:ScriptDirectory\menu\yes-no-menu.ps1")
    . ("$global:ScriptDirectory\menu\parse-list-menu.ps1")
    . ("$global:ScriptDirectory\menu\parse-shortlist-menu.ps1")
    . ("$global:ScriptDirectory\menu\choose-selection-menu.ps1")
    . ("$global:ScriptDirectory\menu\choose-selection-menu-redirected.ps1")
    . ("$global:ScriptDirectory\menu\select-subfolder.ps1")


    . ("$global:ScriptDirectory\resources\res-subscription.ps1")
    . ("$global:ScriptDirectory\resources\res-group.ps1")
    . ("$global:ScriptDirectory\resources\res-hub.ps1")
    . ("$global:ScriptDirectory\resources\res-dps.ps1")
    . ("$global:ScriptDirectory\resources\res-device.ps1")
    . ("$global:ScriptDirectory\resources\run-quickstarts.ps1")
    . ("$global:ScriptDirectory\resources\clr-quickstarts.ps1")
    . ("$global:ScriptDirectory\resources\manage-appdata.ps1")
    . ("$global:ScriptDirectory\resources\res-setup.ps1")
    # . ("$global:ScriptDirectory\resources\res-iot-central.ps1")


    . ("$global:ScriptDirectory\new_delete\new-group.ps1")
    . ("$global:ScriptDirectory\new_delete\new-hub.ps1")
    . ("$global:ScriptDirectory\new_delete\new-device.ps1")
    . ("$global:ScriptDirectory\new_delete\new-dps.ps1")

    . ("$global:ScriptDirectory\new_delete\delete-group.ps1")
    . ("$global:ScriptDirectory\new_delete\delete-hub.ps1")
    . ("$global:ScriptDirectory\new_delete\delete-device.ps1")
    . ("$global:ScriptDirectory\new_delete\delete-dps.ps1")

    . ("$global:ScriptDirectory\azsphere\res-azsphere.ps1")
    . ("$global:ScriptDirectory\azsphere\res-azsphere-dps.ps1")
    . ("$global:ScriptDirectory\azsphere\res-azsphere-iot-central.ps1")
    . ("$global:ScriptDirectory\azsphere\enter-azsphere.ps1")
    . ("$global:ScriptDirectory\azsphere\create-azsphere.ps1")
    . ("$global:ScriptDirectory\azsphere\create-iotcentral.ps1")
    . ("$global:ScriptDirectory\azsphere\show-image.ps1")
    . ("$global:ScriptDirectory\azsphere\show-form.ps1")
    . ("$global:ScriptDirectory\azsphere\whitelist-app-enpoint.ps1")
    . ("$global:ScriptDirectory\azsphere\doall-azsphere-hubdps.ps1")  


    . ("$global:ScriptDirectory\resources\show-splashscreen.ps1")
}
catch {
    Write-Host "Error while loading supporting PowerShell Scripts" 
    Write-Host $_
}

# show-image
# exit
If (-not([string]::IsNullOrEmpty($global:logs )))
{
    write-host ''
    write-host "Any loading errors?"
    get-yesorno $false "Continue"
    $answer = $global:retVal
    if ( $answer)
    {
        exit
    }
}

# & "$global:ScriptDirectory\app-settings"

If (-not([string]::IsNullOrEmpty($global:Time )))
{
    remove-variable Time  -Scope Global
}

$global:DPSUnits=1

#endregion

if ($($args.Count) -ne 0)
{
    If (-not([string]::IsNullOrEmpty($global:yesnowait )))
    {
        remove-variable yesnowait  -Scope Global
    }

    # $global:Location= $null
    # $global:SKU= $null

    if ([string]::IsNullOrEmpty($global:skipLoginCheck)){
        If (-not ([string]::IsNullOrEmpty($global:SubscriptionsStrn)))
        {
            Get-Subscription $global:Subscription
        }
        else{
            Get-Subscription
        }
    }
    If (-not([string]::IsNullOrEmpty($global:skipLoginCheck )))
    {
        remove-variable skipLoginCheck  -Scope Global
    }


    
    $Subscription = $global:Subscription

    $global:Location = get-Location
    $result = $global:retVal
    

    $prompt = 'Location for Resource Group is "' + $result +'"'
    write-Host $prompt

    if ([string]::IsNullOrEmpty($result))
    {
        exit
    }
    elseif ($result -eq 'Back')
    {
        exit
    }
    elseif ($result -eq 'Error')
    {
        exit
    }
    elseif ($result -eq 'Exit')
    {
        exit
    }
    $global:Location = $result


    if ([string]::IsNullOrEmpty($global:SKU)){
        $global:SKU = get-SKU
        $result = $global:retVal

        $prompt = 'SKU for Hub is "' + $result +'"'
        write-Host $prompt

        if ([string]::IsNullOrEmpty($result))
        {
            exit
        }
        elseif ($result -eq 'Back')
        {
            exit
        }
        elseif ($result -eq 'Error')
        {
            exit
        }
        elseif ($result -eq 'Exit')
        {
            exit
        }
        $global:SKU = $result
    }


    switch ($args.Count)
    {
        1{
            if ([string]::IsNullOrEmpty($global:delay)){
                # Assume a csv of 3 or 4
                [string]$arg0 = [string]$($args[0]) 
                $arg0 = $arg0.Replace(' ',',')
                get-allinone $arg0
            }
            else{
                # Assume a csv of 3 or 4
                [string]$arg0 = [string]$($args[0]) 
                $arg0 = $arg0.Replace(' ',',')
                get-allinone $arg0 $global:delay
            }
        }
        2{ 
            #assume a CSV of 3 or 4 and sleepparam
            [string]$arg0 = [string]$($args[0]) 
            $arg0 = $arg0.Replace(' ',',')
            [string]$delay = [string] $($args[1])
            get-allinone $arg0  $delay
        }
        3{ 
            # assum space sep of 3
            $arg0= $($args[0])+' '+$($args[1])+ ' '+$($args[2]) 
            $arg0 = $arg0.Replace(' ',',')
            get-allinone $arg0
        }
        4 {
            # assum space sep of 3  and sleepparam
            $arg0= $($args[0])+' '+$($args[1])+ ' '+$($args[2]) 
            $arg0 = $arg0.Replace(' ',',')
            [string]$delay = [string] $($args[3])
            get-allinone $arg0 $delay
        }
        5{ 
            # assum space sep of 4 and sleepparam
            $arg0= $($args[0])+' '+$($args[1])+ ' '+$($args[2]) + ' '+$($args[3]) 
            $arg0 = $arg0.Replace(' ',',')
            [string]$delay = [string] $($args[4])
            get-allinone $arg0 $delay
        }
    }


    If (-not([string]::IsNullOrEmpty($global:yesnowait )))
    {
        remove-variable yesnowait  -Scope Global
    }
    If (-not([string]::IsNullOrEmpty($global:Location )))
    {
        remove-variable Location  -Scope Global
    }

    If (-not([string]::IsNullOrEmpty($global:SKU )))
    {
        remove-variable SKU  -Scope Global
    }

    if ($global:retVal -eq 'Exit')
    {
        exit
    }

}
else {
    Show-Splashscreen
}







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
else
{
    $global:SpecificVersion="3.1.102"
}

if (Test-Path "$global:ScriptDirectory\set-env.ps1")
{
    & "$global:ScriptDirectory\set-env"
}


show-heading  -Prompt '  S E T U P  ' 1
$answer = ''
[int]$current = 1
$selectionList =@('D1','D2','D3','D4','D5','D6','D7','D8','D9','A','UpArrow','DownArrow','Enter','X','R','S')

# $selections = $selectionList -split ','
$itemsList ='Subscription,Groups,IoT Hubs,Devices,DPS,Environment Variables,Quickstart Apps,Manage App Data,All in one. Get a New: (Group ... Hub in Group ... Device for Hub),Azure Sphere'

$Subscription = $global:Subscription
$GroupName = $Global:GroupName
$HubName = $global:HubName
$DeviceName = $global:DeviceName
$DPSName =$global:DPSName
$Tenant = $global:Tenant
$TenantName = $global:TenantName
[boolean] $GetKey = $true
do
{
    $Subscription = $global:Subscription
    $GroupName = $Global:GroupName
    $HubName = $global:HubName
    $DeviceName = $global:DeviceName
    $DPSName = $global:DPSName
    $Tenant = $global:Tenant
    $TenantName = $global:TenantName
    $Prompt = '   Subscription :"' + $Subscription +'"'
    write-Host $Prompt
    $Prompt = '          Group :"' + $GroupName +'"'
    write-Host $Prompt
    $Prompt = '            Hub :"' + $HubName +'"'
    write-Host $Prompt
    $Prompt = '         Device :"' + $DeviceName +'"'
    write-Host $Prompt
    $Prompt = '            DPS :"' + $DPSName +'"'
    write-Host $Prompt
    $Prompt = '         Tenant :"' + $TenantName +'"'
    write-Host $Prompt
    write-Host ''
    $items =$ItemsList  -split ','
    $i=1
    foreach ($item in $items) 
    {
        if ($i -gt 9)
        {
            [char] $ch = [char] (65 + $i-10)
            [string]$prompt = "$ch"
        } else{
            [string]$prompt = [string]$i
        }
        $prompt += '. '  
        write-Host $prompt  -NoNewline
        $prompt =  $item

        if ($Current -eq 0)
        {
            write-Host $prompt 
        }
        elseif ( $Current -eq $i)
        {
            write-Host $prompt -ForegroundColor Yellow -NoNewline
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
    write-host S. 'Azure CLI Setup'
    write-host ''
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
            'S'    { do-setup}
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
                        read-Host $global:DeviceName
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
                    $current = 5
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
            'D5'  { 
                    $current = 5
                    Get-DPS  $Subscription $GroupName $HubName $DPSName $DeviceName
                    $response = $global:retVal
                    if ( ([string]::IsNullOrEmpty($response)) )
                    {
                        $DPSName = $null
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
                        $DPSName = $response
                    }
                }
            'D6' { Do-Envs $Subscription $GroupName $HubName $DeviceName }
            'D7' { $response = Run-Apps $Subscription $GroupName $HubName $DeviceName
                    if ($response -ne 'Back')
                    {
                        exit
                    }
                }
            'D8' { Manage-AppData}

            'D9' {
                    get-allinone
                    if ($false){
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
                            if (check-hub  $Subscription  $names[1] )
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
                                if (check-hub  $Subscription  $hb )
                                {
                                    $lev++
                                    write-host "[3] Create Device in Hub"
                                    new-device $Subscription $grp $hb $dev
                                    if (check-device  $Subscription $grp $hb $dev )
                                    {
                                        $lev++
                                        write-host "[4] Get connection strings."
                                        get-all  $Subscription $grp $hb $dev
            
                                        $success = $true
                                    }
                                }
                            }
                            if ($success)
                            {
                                write-host "Creation succeeded."
                            }
                            else {
                                write-host "Failed: $lev"
                            }
                            get-anykey        
                        }
                    }
                }
            'A' { 
                get-azsphere $Subscription $GroupName $HubName $DPSName $Tenant $TenantName
                }
            R    { 
                    clear-appData
                    [boolean] $GetKey = $true
                    $Current=1
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
    show-heading  -Prompt '  S E T U P  ' 1
  
} until ($false)

