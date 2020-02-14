function Manage-AppData{


   
    try {
        . ("$global:ScriptDirectory\util\save-appdata.ps1")
        . ("$global:ScriptDirectory\util\get-dncore.ps1")
    }
    catch {
        Write-Host "Error while loading supporting PowerShell Scripts" 
        Write-Host $_
    }

    do {
        util\heading '  S A V E  A P P  D A T A   '  -BG DarkBlue   -FG White
        If (-not([string]::IsNullOrEmpty($global:Subscription )))
        {
            $Prompt = '   $global:Subscription :"' + $global:Subscription +'"'
            write-Host $Prompt
        }
        
        If (-not([string]::IsNullOrEmpty($global:GroupName )))
        {
            $Prompt = '      $global:GroupName :"' + $global:GroupName +'"'
            write-Host $Prompt
        }
        
        If (-not([string]::IsNullOrEmpty($global:HubName )))
        {
            $Prompt = '        $global:HubName :"' + $global:HubName +'"'
            write-Host $Prompt
        }
        
        If (-not([string]::IsNullOrEmpty($global:DeviceName )))
        {
            $Prompt = '     $global:DeviceName :"' + $global:DeviceName +'"'
            write-Host $Prompt
        }





        $itemsList ='Save App Data,Load App Data,Get .NET Core SDK and Runtime,Done'



        choose-selection $itemsList  'Manage App Data Action'   '' ','
        $answer = $global:retVal1
        
        if ( $global:retVal -eq 'Back'){
            return  'Back'
        }

        switch ($answer)
        {
            'D1'    {  save-appdata }
            'D2'    {  if ( Test-Path -Path "$global:ScriptDirectory\app-settings.ps1" ){
                            .\app-settings
                            write-host 'Done' 
                        }
                        else {
                            write-host 'No app-settings.ps1 file'
                        }
                        get-anykey
                    }
            'D3'    {  get-dotnetcore }
            'D4'    {  return 'Back' }
        }  
    }  
    while ($true)
    
}