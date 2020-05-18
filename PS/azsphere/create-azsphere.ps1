function create-azsphere{
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
    write-host ' '
    write-host "The current IoT Hub needs to be connected to the current DPS. See Main Menu-->5. DPS Menu then Options G. then C."
    write-host "Has this been done?"
    get-yesorno $true 'Continue'
    $answer = $global:retVal
    if (-not $answer)
    {
        return
    }

	$CAcertificate="$global:ScriptDirectory\temp\CAcertificateTemp.cer"
    $ValidationCertificationCertificate="$global:ScriptDirectory\temp\ValidationCertificationTemp.cer"
    if (Test-Path $CAcertificate)
    {
        Remove-Item $CAcertificate
    }
    if (Test-Path $ValidationCertificationCertificate)
    {
        remove-item $ValidationCertificationCertificate
    }
    
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

    write-host "Please wait: Checking if Verification Certificate $DPSCertificateName exists already."
    write-host "Ignore errors. They are trapped. Expect to see: " -nonewline
    write-host " Certificate '$DPSCertificateName' not found ..... " -foregroundcolor Red
    $query =  az iot dps certificate show --dps-name $global:DPSName --resource-group $global:GroupName --name $DPSCertificateName
    [Console]::ResetColor()
    if (-not ([string]::IsNullOrEmpty($query)))
    {
        write-host "Please wait: Verification Certificate $DPSCertificateName exists so deleting it."
        $query =az iot dps certificate show --dps-name $global:DPSName --resource-group $global:GroupName --name asd-sdf-qwerty -o tsv |out-string
        $etag= ($query -split '\t')[0]
        $etag = $etag.Trim()
        write-host "Ready to delete certificate $DPSCertificateName on Azure"
        get-yesorno $true "Continue"
        $answer = $global:retVal
        if (-not  $answer)
        {
            return
        }
        write-host "Please wait: Deleting Verification Certificate $DPSCertificateName on Azure."
        az iot dps certificate delete --dps-name $global:DPSName --resource-group $global:GroupName --name $DPSCertificateName --etag $etag
        write-host "Please wait: Done that. Checking if it was deleted."
        write-host "Ignore errors. They are trapped. Expect to see: " -nonewline
        write-host " Certificate '$DPSCertificateName' not found ..... " -foregroundcolor Red
        $query =  az iot dps certificate show --dps-name $global:DPSName --resource-group $global:GroupName --name $DPSCertificateName
        [Console]::ResetColor()
        if (-not([string]::IsNullOrEmpty($query)))
        {
            write-host "$DPSCertificateName Deletion failed"
            get-anykey
            return
        }

    }


    write-host "Please wait: Getting CACertificate from azsphere."
    azsphere tenant download-CA-certificate --output $CAcertificate
    write-host "Got CACertificate"

    write-host "Please wait: Creating new DPS certificate named $DPSCertificateName"
    $cert = az iot dps certificate create --subscription "$subscription" --dps-name $DPSName --resource-group $GroupName --name $DPSCertificateName --path $CAcertificate -o tsv | Out-String
    write-host "Created DPS Certificate:"
    write-host $cert 
    $items= $gh=$cert -split '\t'
    $etag = $items[0].Trim()
    write-host "etag: $etag"
    get-anykey "" "Continue"

    write-host "Please wait: Getting Verification Code for certificate."
    $valid = az iot dps certificate generate-verification-code --subscription "$Subscription" --dps-name $DPSName --resource-group $GroupName --name $DPSCertificateName   --etag $etag -o json| Out-String
    write-host "Generated Verification Code"
    $validationObject = ConvertFrom-Json -InputObject $valid
    $verificationcode = $validationObject.properties.verificationCode
    write-host "Verification Code: $verificationcode"
    get-anykey "" "Continue"

    write-host "Please wait: Downloading Validation Certificate."
    azsphere tenant download-validation-certificate --output $ValidationCertificationCertificate --verificationcode $verificationcode

    write-host ''
    write-host 'Can now verify inscript .. that is here!'
    write-host 'Please wait: Getting updated etag from Azure.'
    $query = az iot dps certificate show --dps-name $global:DPSName --resource-group $global:GroupName --name $DPSCertificateName  -o json | Out-String | ConvertFrom-Json
    $etag = $query.etag
    write-host "Please wait: Running the following on Azure:"
    write-host "az iot dps certificate verify --dps-name $global:DPSName --resource-group $global:GroupName --name $DPSCertificateName --path $ValidationCertificationCertificate  --etag $etag"
    az iot dps certificate verify --dps-name $global:DPSName --resource-group $global:GroupName --name $DPSCertificateName --path $ValidationCertificationCertificate  --etag $etag
    get-anykey
    write-host "Please wait: Checking it WAS Verified."
    $query = az iot dps certificate show --dps-name $global:DPSName --resource-group $global:GroupName --name $DPSCertificateName  -o json | Out-String | ConvertFrom-Json
    $isverified = $query.properties.isverified
    write-host ''
    write-host "Validation certificate $DPSCertificateName IsVerified:  is" -nonewline
    write-host  $isverified -ForegroundColor Yellow
    write-host ''
    get-anykey


    if (Test-Path $CAcertificate)
    {
        Remove-Item $CAcertificate
    }
    if (Test-Path $ValidationCertificationCertificate)
    {
        remove-item $ValidationCertificationCertificate
    }

    Write-Host 'Select Create Enrolment Group next.'
    get-anykey '' 'Continue'
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