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

    write-host "[1] Create New Group in Subscription: $Subscription then ..."
    write-host "[2] Create New Hub in Group then ..."
    write-host "[3] Create Device in Hub then ..."
    write-host "[4] Get connection strings"
    write-host "Continue?"
    get-yesorno $true
    $answer =  $global:retVal


    if ($answer)
    {
        if (-not([string]::IsNullOrEmpty($yesnodelay)) )
        {
            [int]$global:yesnowait= [int]$yesnodelay
            write-host "YesNo and GetAnyKey Pause =  $global:yesnowait"
        }
        else {
            $global:yesnowait= $null
            write-host "No YesNo and GetAnyKey Pause. Will wait."
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