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
    elseIf ([string]::IsNullOrEmpty($DPSName ))
    {
        write-Host ''
        $prompt = 'Need to select a Group first.'
        write-host $prompt
        get-anykey 
        $global:retVal =  'Back'
        return
    }
  

	$CAcertificate="$global:ScriptDirectory\temp\CAcertificateTemp.cer"
    $ValidationCertificationCertificate="$global:ScriptDirectory\temp\ValidationCertificationTemp.cer"
    


    write-host "Getting CACertificate from azsphere (Wait)"
    azsphere tenant download-CA-certificate --output $CAcertificate
    write-host "Got CACertificate"

    write-host 'In Az Central Upload that cert back:'
    set-clipboard $CAcertificate
    write-host "Clipboard contents is: $CAcertificate"
    write-host  " ... Click on the [Primary] Button and paste (Cntrl-v) the cert file path"
    write-host "Press the [Left] Verification Button"
    write-host " Press the Verification [Right] Button"
    get-anykey ''  'Continue'
   
    $verificationcode  = Get-clipboard -format text
    

    write-host "Downloading Validation Certificate"
    azsphere tenant download-validation-certificate --output $ValidationCertificationCertificate --verificationcode $verificationcode

    write-host 'In Az Central Upload:'
    set-clipboard $ValidationCertificationCertificate
    write-host "Clipboard contents is: $ValidationCertificationCertificate"
    write-host "Press [Verify] and paste (cntrl-v) the cert file path Validation cert $ValidationCertificationCertificate and select it." 
    write-host ''

    get-anykey "" "Continue when you have done that"
    Write-Host 'Select Create Enrolment Group next.'
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