<#try {
. ("$global:ScriptDirectory\menu\choose-selection-menu.ps1")
. ("$global:ScriptDirectory\menu\any-key-menu.ps1")
. ("$global:ScriptDirectory\menu\yes-no-menu.ps1")
}
catch {
    Write-Host "Error while loading supporting PowerShell Scripts" 
    Write-Host $_
}#>

function get-iotcentral-template
{
    param ()
    $category = "Custom"
    $template= "Custom"
    $templateCategories = "Custom,Retail,Energy,Government,Healthcare"
    do {
        $category = choose-selection $templateCategories 'Template Categories' 'Custom'
        if ($category -eq 'Back')
        {
            return 'Back'
        }
        
        $templatesCsvList=''
        $templates="" -split ','
        $templateoptions=''
        $done=$false

        # Get list of templates for category
        switch ($global:retVal2)
        {
            '1'{
                $template="iotc-pnp-preview"
                $done=$true;
            }
            '2'{
                $templatesCsvList="iotc-logistics,iotc-distribution,iotc-condition,iotc-store" 
                $templatesCsvList+=",iotc-inventory,iotc-mfc,iotc-video-analytics-om"
                $templates = $templatesCsvList -split ','
                $templateoptions= "Logistics,Digital distribution center,In Store Analytics - condition monitoring ,In-store analytics - checkout"                                
                $templateoptions +=",Smart inventory management,Micro-fulfillment center,Video analytics - object and motion detection"
            }
            '3'{
                $templatesCsvList="iotc-meter,iotc-power"
                $templates = $templatesCsvList -split ','
                $templateoptions= "Smart meter monitoring,Solar panel monitoring"  
            }
            '4'{
                $templatesCsvList="iotc-waste,iotc-consumption,iotc-quality" 
                $templates = $templatesCsvList -split ','
                $templateoptions= "Connected waste management,Water consumption monitoring,Water quality monitoring"
            }
            '5'{
                $templatesCsvList="iotc-patient"
                $templates = $templatesCsvList -split ','
                $templateoptions= "Continuous patient monitoring"    
            }
        }

        # Get template  
        $answer=''                        
        if ( -not $done)
        {
            $templateoptions += ",View Templates' Details"
            $goback=$false
            do {
                                                    
                $answer = choose-selection $templateoptions 'Template' 
                if ($answer -eq 'Back')
                {              
                    $done=$false
                    $goback=$true
                }
                else { 
                    if(($global:retValNum-1) -le $templates.GetUpperBound(0))
                    {
                        $template=$templates[$global:retValNum-1]
                        $done=$true
                        $goback=$false
                    }                 
                    else
                    {
                        write-host ""
                        write-host "====================================================================================="
                        write-host " Going to browser."
                        write-host " Return here when you have decided upon which template to use."
                        write-host " Look at [Learn More]. Not [Create App]."
                        write-host " No need to action anything ([Create App]) in the browser. You make your choice here."
                        write-host "====================================================================================="
                        write-host " Continue to browser?"
                        $resp = get-yesorno $true
                        if($global:retVal)
                        {
                            $url = "https://apps.azureiotcentral.com/build/$category"
                            start-process $url
                        }
                        $done = $false
                        $goback=$false
                    }
                }
            }  until (( $done ) -or (-$goback))                                                                                      
        }
    } until ($done)
    $global:retVal = $template
    return $template
}