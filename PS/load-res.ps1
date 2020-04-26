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


    . ("$global:ScriptDirectory\new_delete\new-group.ps1")
    . ("$global:ScriptDirectory\new_delete\new-hub.ps1")
    . ("$global:ScriptDirectory\new_delete\new-device.ps1")
    . ("$global:ScriptDirectory\new_delete\new-dps.ps1")

    . ("$global:ScriptDirectory\new_delete\delete-group.ps1")
    . ("$global:ScriptDirectory\new_delete\delete-hub.ps1")
    . ("$global:ScriptDirectory\new_delete\delete-device.ps1")
    . ("$global:ScriptDirectory\new_delete\delete-dps.ps1")

    . ("$global:ScriptDirectory\azsphere\res-azsphere-dps.ps1")
    . ("$global:ScriptDirectory\azsphere\res-azsphere-iot-central.ps1")
    . ("$global:ScriptDirectory\azsphere\enter-azsphere.ps1")
    . ("$global:ScriptDirectory\azsphere\create-azsphere.ps1")

    . ("$global:ScriptDirectory\resources\show-splashscreen.ps1")
}
catch {
    Write-Host "Error while loading supporting PowerShell Scripts" 
    Write-Host $_
}

