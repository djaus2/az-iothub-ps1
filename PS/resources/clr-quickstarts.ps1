function clr-apps{
    show-heading '  C L E A R   Q U I K S T A R T  I O T   H U B  A P P S   '  -BG DarkBlue   -FG White
    $prompt =  'Do you want to clear ALL bin and obj folders under Quickstarts?'
    write-Host $prompt
    get-yesorno $true
    $answer = $global:retVal
    if ($answer)
    {
        write-Host 'Clearing all bin and obj folders under Quickstarts'
        write-host "Before:"
        gci  "$global:ScriptDirectory\qs-apps\Quickstarts" -include bin,obj -recurse | write-host 
        $answer = read-host "Press [Enter] to continue....N then [Enter] to abort."
        If (-not([string]::IsNullOrEmpty($answer )))
        {
            if (   ($answer[0] -eq 'N' ) -or ($answer[0] -eq 'n'))
            {
                return 'Back'
            }
        }
        # Ref: https://stackoverflow.com/questions/755382/i-want-to-delete-all-bin-and-obj-folders-to-force-all-projects-to-rebuild-everyt
        gci "$global:ScriptDirectory\qs-apps\Quickstarts" -include bin,obj -recurse | remove-item -force -recurse
        write-host "After:"
        gci  "$global:ScriptDirectory\qs-apps\Quickstarts" -include bin,obj -recurse | write-host
        write-host ''
        read-host 'Done. Pres [Enter] to return'
        $global:retVal ='Back'
        return 'Back'
    }
    else 
    {
        write-Host 'Continuing'
    }



    try {
        . ("$global:ScriptDirectory\util\set-envvar.ps1")
        . ("$global:ScriptDirectory\util\set-export.ps1")
    }
    catch {
        Write-Host "Error while loading supporting PowerShell Scripts" 
        read-host $_
        return
    }


        show-heading '  C L E A R   Q U I K S T A R T  I O T   H U B  A P P S   '  -BG DarkBlue   -FG White

        show-quickstarts "Quickstart/s to run"
    
        show-heading '  C L E A R   Q U I K S T A R T  I O T   H U B  A P P S   '  -BG DarkBlue   -FG White
    
        $answer = $global:retVal
        if ($answer -eq 'Back')
        {
            return $answer
        }
             
        $PsScriptFile = $answer
 
        Write-Host "Setting location to $PsScriptFile."
        write-Host "There are a device and a service apps here:"
        write-Host "clearing all bin and obj folders under $PsScriptFile."
        write-host "Before:"
        gci  "$PsScriptFile" -include bin,obj -recurse | write-host 
        $answer = read-host "Press [Enter] to continue....N then [Enter] to abort."
        If (-not([string]::IsNullOrEmpty($answer )))
        {
            if (   ($answer[0] -eq 'N' ) -or ($answer[0] -eq 'n'))
            {
                return 'Back'
            }
        }
        # Ref: https://stackoverflow.com/questions/755382/i-want-to-delete-all-bin-and-obj-folders-to-force-all-projects-to-rebuild-everyt
        gci "$PsScriptFile" -include bin,obj -recurse | remove-item -force -recurse
        write-host "After:"
        gci  "$PsScriptFile" -include bin,obj -recurse | write-host
        write-host ''
        read-host 'Done. Pres [Enter] to return'
        $global:retVal ='Back'
        return 'Back'
}