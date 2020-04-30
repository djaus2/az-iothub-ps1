function create-iotcentral{
    param (
        [string]$Subscription = '' ,
        [string]$GroupName = '' ,
        [string]$HubName = '' ,
        [string]$DPSName= '',
        [string]$DPSCertificateName= '',
        [string]$EnrollmentGroupName='',
        [boolean]$Refresh=$false
    )
    show-heading '  D P S '  4 'New Certificate and Tenant Verification'
    $Prompt = '   Subscription :"' + $Subscription +'"'
    write-Host $Prompt
    $Prompt = '          Group :"' + $GroupName +'"'
    write-Host $Prompt
    $Prompt = '            Hub :"' + $HubName +'"'
    write-Host $Prompt
    $Prompt = '    Current DPS :"' + $DPSName +'"'
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
    elseIf ([string]::IsNullOrEmpty($HubName ))
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
    

    $url = "https://$IOtCentralName.azureiotcentral.com"
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

    
   
    $verificationcode  = Get-clipboard -format text
    

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
   
function create-iotcentral-enrolmentgroup{
    param (
        [string]$Subscription = '' ,
        [string]$GroupName = '' ,
        [string]$HubName = '' ,
        [string]$DPSName= '',
        [string]$DPSCertificateName= '',
        [string]$EnrollmentGroupName='',
        [boolean]$Refresh=$false
    )


    show-heading '  D P S  '  4  'Create new Enrolment Group'
    if ([string]::IsNullOrEmpty($EnrollmentGroupName))
    {
        $answer = get-name 'DPS Enrollment Group Name'
        if ($answer-eq 'Back')
        {
            write-Host 'Returning'
            $global:retVal = 'Back'
            return
        }
        $EnrollmentGroupName = $answer
    }

    write-host "`nCreating EnrollmentGroup (Wait)`n"
    az iot dps enrollment-group create -g $GroupName --dps-name $DPSName --enrollment-id $EnrollmentGroupName --ca-name $DPSCertificateName
    write-host "`nDone that.`n"
    az iot dps enrollment-group list --dps-name   $DPSName    --resource-group $GroupName


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