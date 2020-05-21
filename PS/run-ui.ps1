# region Include required files
#
$global:ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

If ([string]::IsNullOrEmpty($global:Subscription)) {
    $sub = az account show -o tsv | out-string
    If (-not ([string]::IsNullOrEmpty($sub))) {
        $Current =  (($sub -split '\t')[5]).Trim()
        $global:Subscription = $Current
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

$global:retVal=''
$global:Location= $null
$global:SKU= $null
show-form
If (-not([string]::IsNullOrEmpty($global:retVal )))
{
    if($global:retVal -eq 'Cancel'){
        return
    } else{
        & "$global:ScriptDirectory\get-iothub" $global:retVal
    }
}
else 
{
    & "$global:ScriptDirectory\get-iothub" 
}
