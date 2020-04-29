function create-iotcentralcert{
    param (
        [string]$Subscription = '' ,
        [string]$GroupName = '' ,
        [string]$HubName = '' ,
        [string]$DPSName= '',
        [string]$DPSCertificateName= '',
        [string]$EnrollmentGroupName='',
        [boolean]$Refresh=$false
    )
    show-heading '  N E W  I o T   C E N T R A L  C E R T I F I C A T E '  1
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
    
    if ([string]::IsNullOrEmpty($DPSCertificateName))
    {
        $answer = get-name 'DPS Cretificate'
        if ($answer-eq 'Back')
        {
            write-Host 'Returning'
            $global:retVal = 'Back'
            return
        }
        $DPSCertificateName = $answer
    }

    write-host "Getting CACertificate from azsphere (Wait)"
    azsphere tenant download-CA-certificate --output $CAcertificate
    write-host "Got CACertificate"

    <#
    Upload the tenant CA certificate to Azure IoT Central and generate a verification code
In Azure IoT Central, go to Administration > Device Connection > Manage primary certificate.
Click the folder icon next to the Primary box and navigate to the directory where you downloaded the certificate. If you don't see the .cer file in the list, make sure that the view filter is set to All files (*). Select the certificate and then click the gear icon next to the Primary box.
The Primary Certificate dialog box appears. The Subject and Thumbprint fields contain information about the current Azure Sphere tenant and primary root certificate.
Click the Refresh icon to the right of the Verification Code box to generate a verification code. Copy the verification code to the clipboard.
    
    #>

    write-host "Creating new DPS certificate (Wait):"
    $cert = az iot dps certificate create --subscription $subscription --dps-name $DPSName --resource-group $GroupName --name $DPSCertificateName --path $CAcertificate -o tsv | Out-String
    write-host "Created DPS Certificate:"
    write-host $cert 
    $items= $gh=$cert -split '\t'
    $etag = $items[0].Trim()
    write-host "etag: $etag"
    get-anykey "" "Continue"

    write-host "Getting Verification Code for certificate (Wait):"
    $valid = az iot dps certificate generate-verification-code --subscription $Subscription --dps-name $DPSName --resource-group $GroupName --name $DPSCertificateName   --etag $etag -o json| Out-String
    write-host "Generated Verification Code"
    $validationObject = ConvertFrom-Json -InputObject $valid
    $verificationcode = $validationObject.properties.verificationCode
    write-host "Verification Code: $verificationcode"
    get-anykey "" "Continue"

    write-host "Downloading Validation Certificate"
    azsphere tenant download-validation-certificate --output $ValidationCertificationCertificate --verificationcode $verificationcode

    write-host ''
    write-host "Sorry but can't script next step yet, so you have to go to the Portal:" 
    write-host ''
    write-host "Uploading Validation Certificate:"  -BackgroundColor DarkRed  -ForegroundColor   Yellow
    write-host "Go to the Azure Portal.`n- Go to Device Provisioning Services.`n- Choose $DPSName.`n- Select Certificates.`n- Select $DPSCertificateName.`n     Ignore Verification Code...Done that."
    write-host "- Upload the Validation Certificate: Click in last box at bottom 'Select a File' and browse to it."
    write-host "Then Verify the Certificate (Click on [Verify])." -BackgroundColor DarkRed  -ForegroundColor   Yellow

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
   
function create-enrolmentgroup{
    param (
        [string]$Subscription = '' ,
        [string]$GroupName = '' ,
        [string]$HubName = '' ,
        [string]$DPSName= '',
        [string]$DPSCertificateName= '',
        [string]$EnrollmentGroupName='',
        [boolean]$Refresh=$false
    )
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