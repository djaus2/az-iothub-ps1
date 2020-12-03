function verify-tenant-iotcentral{
    param (
        [string]$Subscription = '' ,
        [string]$GroupName = '' ,
        [string]$IoTCentralName = '' ,
        [string]$IOTCentralURL= '',
        [string]$Tenant='',
        [String]$TenantName='',
        [boolean]$Refresh=$false
    )
    $EnrollmentGroup=''
    show-heading '  I O T   C E N T R A L '  4 'New Certificate and Tenant Verification'
    $Prompt = '   Subscription :"' + $Subscription +'"'
    write-Host $Prompt
    $Prompt = '            Group :"' + $GroupName +'"'
    write-Host $Prompt
    $Prompt = '              Hub :"' + $IoTCentralName +'"'
    write-Host $Prompt
    $Prompt = '    IoTCentralURL :"' + $IOTCentralURL +'"'
    write-Host $Prompt
    $Prompt = '  EnrollmentGroup :"' + $EnrollmentGroup +'"'
    write-Host $Prompt
  


    If ([string]::IsNullOrEmpty($Subscription ))
    {
        write-Host ''
        $prompt =  'Need to select a Subscription first.'
        write-host $prompt
        get-anykey 
        $global:retVal =  'Back'
        return
    }
    elseIf ([string]::IsNullOrEmpty($GroupName ))
    {
        write-Host ''
        $prompt = 'Need to select a Group first.'
        write-host $prompt
        get-anykey 
        $global:retVal =  'Back'
        return
    }
    elseIf ([string]::IsNullOrEmpty($IOtCentralName ))
    {
        write-Host ''
        $prompt = 'Need to select your IoT Central Name.'
        write-host $prompt
        $IOtCentralName = read-host 'Please enter your IoT Central Name' 
        If ([string]::IsNullOrEmpty($IOtCentralName ))
        {
            return
        }    
    }
    elseIf ([string]::IsNullOrEmpty($Tenant ))
    {
        write-Host ''
        $prompt = 'Need to get Tenant first.'
        write-host $prompt
        get-anykey 
        $global:DPS =  'Back'
        return
    }
    elseIf ([string]::IsNullOrEmpty($TenantName ))
    {
        write-Host ''
        $prompt = 'Need to get Tenant first.'
        write-host $prompt
        get-anykey 
        $global:DPS =  'Back'
        return
    }
    $url =$IOTCentralURL
    If ([string]::IsNullOrEmpty($IoTCentralUrl ))
    {
        write-Host ''
        $prompt = 'Need to get your IoT Central URL.'
        write-host $prompt
        $IOtCentralUrl = read-host 'Please enter your IoT Central URL' 
        $Prompt
        If ([string]::IsNullOrEmpty($IOtCentralUrl ))
        {
            $url = "https://$IOtCentralName.azureiotcentral.com"
        } 
    }
    if (-not ($IOTCentralURL.Contains("https://")))
    {
        $url ="https://$IOTCentralURL"
    } 

    # need to create temp if it doesn't exist
    New-Item -ItemType Directory -Force -Path "$global:ScriptDirectory\temp"
    $CAcertificate="$global:ScriptDirectory\temp\CAcertificateTemp.cer"
    $ValidationCertificationCertificate="$global:ScriptDirectory\temp\ValidationCertificationTemp.cer"
    $stepNo = 0
    $auto=$false
    $otherSteps =@(2,4,6,9)
    $doneAction=$false
    do {

        show-heading '  I O T   C E N T R A L '  4 'New Certificate and Tenant Verification'
        $Prompt = '   Subscription :"' + $Subscription +'"'
        write-Host $Prompt
        $Prompt = '            Group :"' + $GroupName +'"'
        write-Host $Prompt
        write-host ' ------------------------------------ '
        $Prompt = '      Tenant Name :"' + $TenantName +'"'
        write-Host $Prompt
        $Prompt = '           Tenant :"' + $Tenant +'"'
        write-Host $Prompt
        $Prompt = '              Hub :"' + $IoTCentralName +'"'
        write-Host $Prompt
        $Prompt = '    IoTCentralURL :"' + $IOTCentralURL +'"'
        write-Host $Prompt
        $Prompt = '  EnrollmentGroup :"' + $EnrollmentGroup +'"'
        write-Host $Prompt
        if (($doneAction) -and ( $auto))
        {
            write-host ''
            $curStep = $stepNo -1
            write-host "Just done step: $curStep"
            get-anykey "When you return here," "press any key to continue."
        }

        show-heading '  I O T   C E N T R A L '  4 'New Certificate and Tenant Verification'
        $Prompt = '   Subscription :"' + $Subscription +'"'
        write-Host $Prompt
        $Prompt = '            Group :"' + $GroupName +'"'
        write-Host $Prompt
        write-host ' ------------------------------------ '
        $Prompt = '      Tenant Name :"' + $TenantName +'"'
        write-Host $Prompt
        $Prompt = '           Tenant :"' + $Tenant +'"'
        write-Host $Prompt
        $Prompt = '              Hub :"' + $IoTCentralName +'"'
        write-Host $Prompt
        $Prompt = '    IoTCentralURL :"' + $IOTCentralURL +'"'
        write-Host $Prompt
        $Prompt = '  EnrollmentGroup :"' + $EnrollmentGroup +'"'
        write-Host $Prompt

        write-host ''
        write-host "A: Auto Mode. Start now."
        write-host "========================"
        write-host "0. "  -NoNewline 
        write-host "Get CACertificate from azsphere (Here)" -ForegroundColor   Blue 
        write-host "1. "  -NoNewline 
        write-host "HOW TO: " -NoNewline -ForegroundColor   Green
        write-host "Create EnrollmentGroup -1 ."
        write-host "2. "  -NoNewline 
        write-host " Open App Portal and do 1."  -ForegroundColor   Magenta
        write-host "3. "  -NoNewline 
        write-host "HOW TO: " -NoNewline -ForegroundColor   Green
        write-host "Create EnrollmentGroup -2 ."  
        write-host "4. " -NoNewline
        write-host " Alt-Tab back to Portal and do 3."  -ForegroundColor   Magenta 
        write-host "5. "  -NoNewline
        write-host "HOW TO: " -NoNewline -ForegroundColor   Green
        write-host "Generate Verification Code." 
        write-host "6. "  -NoNewline
        write-host " Alt-Tab back to Portal and do 5."  -ForegroundColor   Magenta 
        write-host "7. "  -NoNewline 
        write-host "Generate Verification Code (Here)" -ForegroundColor   Blue
        write-host "8. "  -NoNewline 
        write-host "HOW TO: " -NoNewline -ForegroundColor   Green
        write-host "Upload Verification Certificate"  
        write-host "9. " -NoNewline
        write-host " Alt-Tab back to Portal and do 8"  -ForegroundColor   Magenta 
        write-host "=========================================================="
        write-host "Next step: $stepNo"
        write-host "D: Done"
        write-host "B. Back"
        write-host ''
        if ($stepNo -eq 0){
            Write-host "Complete each of these steps in order, by press 0..9 in that order."
            Write-Host "Steps 0. and 7. are completed here."
            Write-host "For steps 1,3,5 and 8 are a screen dumps with somae annotations, showng what to do."
            write-host "You are taken to the App's Portal to perform those actions in steps 2,,6 and 9."
            write-host 'Alt-Tabs are done automatically.'
            write-host 'Default: Do next step'
        }
        $doneAction=$false

        if (-not $auto) {
            $KeyPress = [System.Console]::ReadKey($true)
            $K = $KeyPress.Key
            $KK = $KeyPress.KeyChar

            if ($kk -eq 'B')
            {
                return;
            }
            elseif ($kk -eq 'D')
            {
                return;
            }
            elseif ($kk -eq 'A')
            {
                $auto=$true
            }

            switch ( $k )
            {
                'D0'  {$stepNo = 0  }
                'D1'  {$stepNo = 1  }
                'D2'  {$stepNo = 2  }
                'D3'  {$stepNo = 3  }
                'D4'  {$stepNo = 4  }
                'D5'  {$stepNo = 5  }
                'D6'  {$stepNo = 6  }
                'D7'  {$stepNo = 7  }
                'D8'  {$stepNo = 8  }
                'D9'  {$stepNo = 9  }
            } 
        }


        switch ( $stepNo )
        {
            # Numerical Keys 0 to 9


            0  {
                show-heading '  I O T   C E N T R A L '  4 'New Certificate and Tenant Verification'
                $Prompt = '   Subscription :"' + $Subscription +'"'
                write-Host $Prompt
                $Prompt = '            Group :"' + $GroupName +'"'
                write-Host $Prompt
                write-host ' ------------------------------------ '
                $Prompt = '      Tenant Name :"' + $TenantName +'"'
                write-Host $Prompt
                $Prompt = '           Tenant :"' + $Tenant +'"'
                write-Host $Prompt
                $Prompt = '              Hub :"' + $IoTCentralName +'"'
                write-Host $Prompt
                $Prompt = '    IoTCentralURL :"' + $IOTCentralURL +'"'
                write-Host $Prompt
                $Prompt = '  EnrollmentGroup :"' + $EnrollmentGroup +'"'
                write-Host $Prompt
                write-host ''
                write-host "Doing step: 0."
                write-host ''
                write-host "Getting CACertificate from azsphere (Wait)"
                if (Test-Path $CAcertificate)
                {
                    write-host "You have a previously obtained a Certificate"
                    get-yesorno $false "Use that? [Y]es [N]o"
                    if (-not $global:retVal)
                    {        
                        Remove-Item $CAcertificate
                    }
                }
                if (-not ( Test-Path $CAcertificate))
                {
                    # Previous: azsphere tenant download-CA-certificate --output $CAcertificate
                    azsphere ca-certificate download  --output $CAcertificate
                    write-host "Got CACertificate"
                }
            
                write-host "Got CACertificate"
                set-clipboard $CAcertificate
              }
            1  { show-image 'iot-central-new-3-V2.png' 'Open Verify' ''}
            2  { start-process  $url ;$doneAction=$true }
            3  { show-image 'iot-central-new-4-V2.png' 'Open Verify' ''}
            4  {do-alttab; $doneAction=$true}
            5  { show-image 'iot-central-new-5-V2.png' 'Open Verify' ''}
            6  {do-alttab; $doneAction=$true}
            7  { 
                show-heading '  I O T   C E N T R A L '  4 'New Certificate and Tenant Verification'
                $Prompt = '   Subscription :"' + $Subscription +'"'
                write-Host $Prompt
                $Prompt = '            Group :"' + $GroupName +'"'
                write-Host $Prompt
                write-host ' ------------------------------------ '
                $Prompt = '      Tenant Name :"' + $TenantName +'"'
                write-Host $Prompt
                $Prompt = '           Tenant :"' + $Tenant +'"'
                write-Host $Prompt
                $Prompt = '              Hub :"' + $IoTCentralName +'"'
                write-Host $Prompt
                $Prompt = '    IoTCentralURL :"' + $IOTCentralURL +'"'
                write-Host $Prompt
                $Prompt = '  EnrollmentGroup :"' + $EnrollmentGroup +'"'
                write-Host $Prompt
                write-host ''
                write-host "Doing step: 7."
                write-host ''
                write-host "Downloading Validation Certificate with Verification code: $verificationcode"
                write-host "azsphere tenant download-validation-certificate --output $ValidationCertificationCertificate --verificationcode $verificationcode"  
                set-clipboard $ValidationCertificationCertificate
                get-anykey
            }
            8  { show-image 'iot-central-new-6-V2.png' 'Open Verify' ''}
            9  {do-alttab}
        }
        $stepNo +=1
        if ($stepNo -gt 9 )
        {
            return
        }

    } while ($true)
    

    
    # $url = "https://$IOtCentralName.azureiotcentral.com/admin/device-connection"
    write-host ''
    write-host "About to open $url"
    write-host 'Please return here when its open'
    write-host 'If app there is just starting, and you get an error messgae, try a page refresh in the browser.'
    start-process  $url
    get-anykey '' 'Continue'
    show-image 'iot-central-new-3-V2.png' 'Open Verify' ''
    get-anykey '' 'Continue'
    show-image 'iot-central-new-3-V2.png' 'Open Verify' ''
    write-host "Doing 1. Getting CACertificate from azsphere (Wait)"

    if (-not (Test-Path "$global:ScriptDirectory\temp"))
    {
        New-Item -ItemType Directory -Force -Path "$global:ScriptDirectory\temp"
    }

    # need to create temp if it doesn't exist
    New-Item -ItemType Directory -Force -Path "$global:ScriptDirectory\temp"
    $CAcertificate="$global:ScriptDirectory\temp\CAcertificateTemp.cer"
    $ValidationCertificationCertificate="$global:ScriptDirectory\temp\ValidationCertificationTemp.cer"
        
    write-host "Getting CACertificate from azsphere (Wait)"
    if (Test-Path $CAcertificate)
    {
    	write-host "You have a previously obtained a Certificate"
        get-yesorno $false "Use that? [Y]es [N]o"
        if (-not $global:retVal)
        {        
            Remove-Item $CAcertificate
        }
    }
    if (-not ( Test-Path $CAcertificate))
    {
        # Previous: azsphere tenant download-CA-certificate --output $CAcertificate
        azsphere ca-certificate download  --output $CAcertificate
        write-host "Got CACertificate"
    }

    write-host "Got CACertificate"
    set-clipboard $CAcertificate
    write-host ''
    write-host 'Now going to show the steps on that dialog to follow.'
    write-host '1. was done just now here.'
    write-host 'The ones in red are done here. The others on the dialog'
    get-anykey '' 'Show the steps'
    show-image 'tenant-verify.png' 'Verify' ''
    write-host ''

    
   
    $verificationcode  = Get-clipboard # -format text
    

    write-host "Doing 5. Downloading Validation Certificate with Verification code: $verificationcode"
    azsphere tenant download-validation-certificate --output $ValidationCertificationCertificate --verificationcode $verificationcode

    write-host 'In the dialog Do 6.'
    set-clipboard $ValidationCertificationCertificate
    write-host "Clipboard contents is in : $ValidationCertificationCertificate"
    write-host "Press [Verify] and paste (cntrl-v) the cert file path Validation cert $ValidationCertificationCertificate and select it." 
    write-host '>> Do step 5 now in the dialog.'

    get-anykey "" "Continue when you have done that"
    Write-Host 'When the dialog show Verified, you are done and you can close it..'
    get-anykey '' 'Continue'
    if (Test-Path $CAcertificate)
    {
        Remove-Item $CAcertificate
    }
    if (Test-Path $ValidationCertificationCertificate)
    {
        remove-item $ValidationCertificationCertificate
    }
}
   
function create-iotcentral-app{
    param (
        [string]$Subscription = '' ,
        [string]$GroupName = '' ,
        [string]$Iotcentralname =''
    )


    show-heading '  Azure Sphere '  4  'Create IoT Central App'

    Set-clipboard " "

    write-host ''
    write-host "Creating an Azure Sphere Learning Path Azure IoT App using its Template"
    write-host "Ref: https://github.com/gloveboxes/Azure-Sphere-Learning-Path: Lab 2"
    write-host ''
    write-host "Thanks To Dave Glover, Microsoft."
    write-host ''
    write-host 'On the template page you need to do the following:'
    write-host 'Click on Build'
    write-host '1.  Name your application.'
    write-host '2. Select the Free pricing plan.'
    write-host '3. Complete any required fields.'
    write-host '4. Click Create to create the Azure IoT Central Application.'
    write-host '5. Copy the URL'
    write-host 'Nb: If you already have a free IoT Central app then delete it first'
    write-host 'And make sure you are logged into your Azsphere Tenant'
    get-anykey '' 'to open the page'
    $url = "https://apps.azureiotcentral.com/build/new/dba50ef5-fb7d-4260-8a5e-a4592677af4f"
    start-process  $url
    get-anykey '' 'Continue when template is open (here)'

    show-image 'create-azapp.png' 'Configure Azure Sphere Learning Path Azure IoT App' ''

    $appName= Get-clipboard # -format text
    $appName = $appName.Trim()

    if (-not([string]::IsNullOrEmpty($appName)))
    {
        $NewString = $appName  -replace ".azureiotcentral.*"
        $NewString = $newstring.Replace('https://','')
        $appName= $newstring.Trim()
    }

    if ([string]::IsNullOrEmpty($appName))
    {
        $appName=read-host 'What app name did you use?'
    }

    $global:iotcentralname = $appname
    set-clipboard $appname
    write-host "Using $global:iotcentralname as the app name"
    get-anykey '' 'Finish'

}

<#
# # Test by entering .\create-dps-cert

# show-heading calls this. Make a dummy call here:
function show-time{}# Uses this this script


# Entry point if run alone:
# ==============================
$global:ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
# Uses thes two scripts
. ("$global:ScriptDirectory\util\show-heading.ps1")
. ("$global:ScriptDirectory\menu\yes-no-menu.ps1")
. ("$global:ScriptDirectory\menu\any-key-menu.ps1")
$headingfgColor_1="Black"
$headingbgColor_1="Green"
create-azsphere $global:subscription $global:groupname $global:hubname $global:dpsname  "First" "EnrollmeNow"
#>


