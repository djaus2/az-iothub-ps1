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
    [bool]$doAzsphere=$false
    $global:azspheresummary =''
    show-heading  -Prompt '  D O  A L L  ' 2

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
        write-host "$Number of Azure entities to create: $names.Length"
        if ($names.Length -ne 3)
        {
            if ($names.Length -ne 4)
            {
                write-host $namesStrn
                write-host $names.Length
                return 'Back 2'
            }
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
        if (check-hub  $Subscription $names[1] )
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
        if ($names.Length -gt 3){
            if ($false) { #Like dev check
                if (check-dps  $Subscription $names[0]  $names[3] )
                {
                    return 'Back 7'
                }
            }
        }
        $grp = $names[0]
        $hb =''
        if ($names.Length -gt 1){
            $hb =$names[1]
        }
        $dev=''
        if ($names.Length -gt 2){
            $dev =$names[2]
        }  
        $dps ="Add a 4th parameter to the list for this"
        [bool]$doDPS=$false
        if ($names.Length -gt 3){
            $dps = $names[3]
            $doDPS=$true
            write-host "Do you want to setup for Azsphere IoT Hub - DPS app?"
            get-yesorno $true "Do you want to do that?"

            if ($global:retVal){
                $doAzsphere=$true
            }
        }

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

        write-host "[4] Get connection strings and Save to shell scripts etc (ps1,sh,json) then ..."



        write-host "[5] Create a New Device Provisioning Service "  -NoNewline
        write-host " $dps " -BackgroundColor Yellow   -ForegroundColor   Black  -NoNewline
        write-host "  then ... "
        write-host "[6] Connect the IoT Hub to the DPS." - nonewline
        write-host " then... "
        write-host "[7] Setup Azsphere, and Verify Tenant with Certificates."

        write-host ''

        write-host "Entity mames are unused (n.b. Device and DPS not checked here ... coming) so good to go ..."

        get-yesorno $true "Continue? (Y/N)"

        $answer = $global:retVal
        if (-not $answer)
        {
            $global:retVal = 'Exit'
            return 'Exit'
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

        start-time     

        [boolean]$success=$false
        $lev=0
        write-host "[1] Create New Group in Subscription: $Subscription"
        new-group $Subscription $grp
        if   ( check-group $Subscription $grp  )
        {
            $global:GroupName = $grp
            $lev++
            write-host "[2] Create New Hub in Group"
            new-hub $Subscription $grp $hb
            if (check-hub  $Subscription  $hb )
            {
                $global:HubName = $hb
                $lev++
                write-host "[3] Create Device in Hub"
                new-device $Subscription $grp $hb $dev
                if (check-device  $Subscription $grp $hb $dev )
                {
                    $global:DeviceName = $dev
                    $lev++
                    write-host "[4] Get connection strings."
                    get-all  $Subscription $grp $hb $dev
                    if($doDPS){
                        write-host "[5] Create Device DPS"
                        new-dps $Subscription $grp $dps

                        if (check-dps  $Subscription $grp $dps )
                        {
                            $global:DPSName = $dps
                            $lev++
                            if ($doAzsphere)
                            {
                                get-anykey "Do AzSphere setup etc."
                                doall-azsphere-iothub-dps $Subscription $grp $hb $dps $global:Tenant $global:TenantName
                            }                        
                        }
                    }
                    $success = $true
                }
            }
        }
        if ($sucess)
        {
            show-heading  -Prompt '  D O  A L L : DONE ' 2
            write-host "Creation succeeded."
        }
        else {
            show-heading  -Prompt '  D O  A L L : FAILED ' 2
            write-host "Failed: $lev"
        }

        get-anykey
    
        Save-AppData

        show-heading  -Prompt ' D O  A L L - S U M M A R Y  ' 1
        write-host "These entities were created:"
        write-host ''
        $Subscription = $global:Subscription
        $GroupName = $Global:GroupName
        $HubName = $global:HubName
        $DeviceName = $global:DeviceName
        $DPSName = $global:DPSName
        $Prompt = 'In Subscription :"' + $Subscription +'"'
        write-Host $Prompt
        if ($lev -gt 0)
        {
            $Prompt = '          Group :"' + $GroupName +'"'
            write-Host $Prompt
            if ($lev -gt 1)
            {
                $Prompt = '            Hub :"' + $HubName +'"'
                write-Host $Prompt
                if ($lev -gt 2)
                {
                    $Prompt = '         Device :"' + $DeviceName +'"'
                    write-Host $Prompt
                    if (($lev -gt 3) -and ($doDPS))
                    {
                        $Prompt = '            DPS :"' + $DPSName +'"'
                        write-Host $Prompt
                    }
                }
            }
        }
        if (-not ([string]::IsNullOrEmpty($global:azspheresummary)) )
        {
            write-host $global:azspheresummary
        }
        $dir = "$global:ScriptDirectory\qs-apps\Quickstarts"
        write-host ''
        write-host "These files were created in $dir :"
        get-childitem -path $dir -name -include  *.json,set-env.*
        if (-not ([string]::IsNullOrEmpty($global:azspheresummary)) )
        {
            $PsScriptFile =  "$global:ScriptDirectory\app_manifest.json"
            if (Test-Path $PsScriptFile ){
                $jsn = Get-Content $PsScriptFile 
                set-clipboard $jsn
                write-host "And app_manifest.json is in $global:ScriptDirectory\app_manifest.json"
                write-host "   ... which is now on the clipboard for pasting into your AzSphere app."
            }
        }
        get-anykey
 

        
        If (-not([string]::IsNullOrEmpty($global:yesnowait )))
        {
            remove-variable yesnowait  -Scope Global
        }
        stop-time
     
    }
}