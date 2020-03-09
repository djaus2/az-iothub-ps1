function get-allinone
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $namesStrn='',
        [Parameter()]
        [string]
        $yesnodelay=$null

    )

    show-heading  -Prompt '  D O  A L L  ' 2

    if($false){
        write-host "[1] Create New Group in Subscription: "  -NoNewline
        write-host $Subscription -BackgroundColor DarkRed  -ForegroundColor   White  -NoNewline
        if (-not([string]::IsNullOrEmpty($global:Location)) )
        {
            write-host " in Location: " -NoNewline
            write-host $global:Location -BackgroundColor DarkRed  -ForegroundColor   White  -NoNewline
        }
        write-host " then ..."
        
        if (-not([string]::IsNullOrEmpty($global:SKU)) )
        {
            write-host "[2] Create New Hub with SKU " -NoNewline
            write-host $global:SKU -BackgroundColor DarkRed  -ForegroundColor   White  -NoNewline
        }
        else{
            write-host "[2] Create New Hub in Group"  -NoNewline
        }
        write-host " then ..."

    
        write-host "[3] Create New Device for Hub then ..."
        
        write-host "[4] Get connection strings and Save to shell script."
        write-host ''
        write-host "Entity Names " -nonewline
        write-host "(Group,Hub and Device)" -BackgroundColor DarkRed  -ForegroundColor   White  -NoNewline
        write-host " are:" 
        $namesStrn -split ','
        write-host ''
        write-host "Continue?"
        get-yesorno $true
        $answer =  $global:retVal
    }

    $answer =$true

    if ($answer)
    {

        If (-not([string]::IsNullOrEmpty($global:yesnowait )))
        {
            remove-variable yesnowait  -Scope Global
        }


        if ([string]::IsNullOrEmpty($namesStrn)) 
        {
            $namesStrn = read-host Enter GroupName,HubName,DeviceName as CSV string
        }
        write-host "Validating the CSV list"
        if ([string]::IsNullOrEmpty($namesStrn)) 
        {
            write-host 'Empty string'
            return 'Back 1'
        }
        $names = $namesStrn -split ','
        if ($names.Length -ne 3)
        {
            write-host $namesStrn
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

        show-heading  -Prompt '  D O  A L L  ' 2

        write-host "[1] Create New Group " -NoNewline
        write-host  " $grp "  -BackgroundColor Yellow  -ForegroundColor   Black  -NoNewline
        write-host " in Subscription: "  -NoNewline
        write-host " $Subscription " -BackgroundColor DarkRed  -ForegroundColor   Black  -NoNewline
        if (-not([string]::IsNullOrEmpty($global:Location)) )
        {
            write-host " in Location: " -NoNewline
            write-host " $global:Location " -BackgroundColor DarkGreen  -ForegroundColor   Black  -NoNewline
        }
        write-host " then ..."
        
        if (-not([string]::IsNullOrEmpty($global:SKU)) )
        {
            write-host "[2] Create New Hub " -nonewline
            write-host " $hb "  -BackgroundColor Yellow   -ForegroundColor   Black  -NoNewline
            write-host " with SKU " -NoNewline
            write-host " $global:SKU " -BackgroundColor DarkGreen  -ForegroundColor   Black  -NoNewline
            write-host " in that Group"  -NoNewline
        }
        else{
            write-host "[2] Create New Hub "  -NoNewline
            write-host " $hb "   -BackgroundColor Yellow  -ForegroundColor   Black  -NoNewline
            write-host " in that Group"  -NoNewline
        }
        write-host " then ..."
    
      
        write-host "[3] Create New Device " -NoNewline
        write-host " $dev " -BackgroundColor Yellow   -ForegroundColor   Black  -NoNewline
        write-host " for that Hub then ..."
        
        write-host "[4] Get connection strings and Save to shell script."
        write-host ''


        get-yesorno $true "Continue? (Y/N)"

        $answer = $global:retVal
        if (-not $answer)
        {
            return 'Back'
        }

        if (-not([string]::IsNullOrEmpty($yesnodelay)) )
        {
            [int]$global:yesnowait= [int]$yesnodelay
            write-host "YesNo and GetAnyKey Pause =  $global:yesnowait"
        }
        else {
            $global:yesnowait= $null
            write-host "No YesNo and GetAnyKey Pause. Will wait."
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
        
        If (-not([string]::IsNullOrEmpty($global:yesnowait )))
        {
            remove-variable yesnowait  -Scope Global
        }
     
    }
}