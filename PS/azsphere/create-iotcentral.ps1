function verify-tenant-iotcentral{
    param (
        [string]$Subscription = '' ,
        [string]$GroupName = '' ,
        [string]$IoTCentralName = '' ,
        [string]$IOTCentralURL= '',
        [boolean]$Refresh=$false
    )
    show-heading '  D P S '  4 'New Certificate and Tenant Verification'
    $Prompt = '   Subscription :"' + $Subscription +'"'
    write-Host $Prompt
    $Prompt = '          Group :"' + $GroupName +'"'
    write-Host $Prompt
    $Prompt = '            Hub :"' + $IoTCentralName +'"'
    write-Host $Prompt
    $Prompt = '    Current DPS :"' + $IoTCentralURL +'"'
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


    If ([string]::IsNullOrEmpty($IOtCentralName ))
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
    $url =$IOTCentralURL
    If ([string]::IsNullOrEmpty($IoTCentralUrl ))
    {
        write-Host ''
        $prompt = 'Need to get your IoT Central YRL.'
        write-host $prompt
        $IOtCentralUrl = read-host 'Please enter your IoT Central URL' 
        $url =$IOTCentralURL
        If ([string]::IsNullOrEmpty($IOtCentralUrl ))
        {
            $url = "https://$IOtCentralName.azureiotcentral.com"
        }    
    }
    

    
    # $url = "https://$IOtCentralName.azureiotcentral.com/admin/device-connection"
    write-host ''
    write-host "About to open $url"
    write-host 'Please return here when its open'
    get-anykey '' 'Open it'
    start-process  $url
    get-anykey '' 'Continue'
    show-image 'iot-central-new-3.png' 'Open Verify' ''

	$CAcertificate="$global:ScriptDirectory\temp\CAcertificateTemp.cer"
    $ValidationCertificationCertificate="$global:ScriptDirectory\temp\ValidationCertificationTemp.cer"
    


    write-host "Doing 1. Getting CACertificate from azsphere (Wait)"
    azsphere tenant download-CA-certificate --output $CAcertificate
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