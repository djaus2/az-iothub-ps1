function Manage-AppData{


   
    try {
        . ("$global:ScriptDirectory\util\save-appdata.ps1")
    }
    catch {
        Write-Host "Error while loading supporting PowerShell Scripts" 
        Write-Host $_
    }

    do {
        show-heading '  S A V E  A P P  D A T A   '  2
        
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
        If (-not([string]::IsNullOrEmpty($global:DPSName )))
        {
            $Prompt = '     $global:DPSName :"' + $global:DPSName +'"'
            write-Host $Prompt
        }
        If (-not([string]::IsNullOrEmpty($global:SpecificVersion )))
        {
            $Prompt = '     $global:SpecificVersion :"' + $global:SpecificVersion +'"'
            write-Host $Prompt
        }





        $itemsList ='Save App Data,Clear AppData,Load App Data,Get,Set prompt pause to 5 sec,Clear prompt pause'



        choose-selection $itemsList  'Manage App Data Action'   '' ','
        $answer = $global:retVal1
        
        if ( $global:retVal -eq 'Back'){
            return  'Back'
        }

        switch ($answer)
        {
            'D1'    {  save-appdata }
            'D2'    {clear-appData }
            'D3'    {  if ( Test-Path -Path "$global:ScriptDirectory\app-settings.ps1" ){
                            .\app-settings
                            write-host 'Done' 
                        }
                        else {
                            write-host 'No app-settings.ps1 file'
                        }
                        get-anykey
                    }
            'D4'    {  return 'Back' }
            'D5'    { 
                $global:yesnowait = 5
             }
            'D6'    {  $global:yesnowait = $null }
        }  
    }  
    while ($true)
    
}