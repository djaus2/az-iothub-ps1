function doall-azsphere-iothub-dps
{
    param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$DPSName = '',
    [string]$Tenant='',
    [String]$TenantName=''
)

    show-heading ' DOAll -  A Z U R E  S P H E R E  '  3 'Connect Via IoT Hub and DPS - Get DPS ID Scope'
    write-host 'Please wait. Connecting IoTHub and DPS in Azure.'
    write-host 'Nb: If already connected, an error wil show but will be ignored. All OK.'
    connect-dps $global:subscription $global:groupname $global:hubname $global:dpsname
    show-dps $global:subscription $global:groupname $global:hubname $global:dpsname
    write-host 'Please wait: Checking AzSphere Login.'
    If ([string]::IsNullOrEmpty($global:AzSphereLoggedIn ))
    {
        write-host ''
        enter-azsphere
        $global:AzSphereLoggedIn ="LoggedIn"
    }
    write-host 'Please wait: Checking/Getting Tenant.'
    If ([string]::IsNullOrEmpty($global:TenantName ))
    {
        $Tenant=$null
        $TenantName=$null
        $getTenant = azsphere tenant show-selected
        If ([string]::IsNullOrEmpty($getTenant))
        {
            write-host "No Tenants or None Selected"
            get-anykey '' "Continue"
        }
        else
        {
            $getTenantLines = $getTenant -split ' '
            [int] $numLines = $getTenantLines.Count
            if ($numLines -ne 8)
            {
                write-host $getTenant
                write-host 'Invalid return from Show Selected Tenant query'
                get-anykey '' "Coninue"
            }
            else
            {
                $ten = $getTenantLines[$numLines-1]
                $tenName = $getTenantLines[$numLines-2]
                $Tenant = $ten.Substring(1,$ten.Length-3)
                $TenantName= $tenName.Substring(1,$tenName.Length-2)
                write-host "TenantName: $TenantName Tenant: $Tenant"
                get-anykey '' "Coninue"
            }
        }
        $global:Tenant= $Tenant
        $global:TenantName = $TenantName
    }

    If  ([string]::IsNullOrEmpty($global:TenantName ))
    {
        $tl= azsphere tenant list
        if ($tl.Length  -lt 3)
        {
            write-host 'No Tenants available'
            read-host ' '
        }
        else
        {
            [int]$numTenants=$tl.Length-2
            write-host "There are $numTenants Tenants"
            $start = 2
            $stop = 2 + $numTenants 
            write-host ''
            write-host "Select the Tenant"
            for ($i=$start;$i -lt $stop;$i++)
            {
                $var = $tl[$i]
                $z = $var -split ' '
                write-host ($i-1) $z[1]  $z[0]
            }
            $numStrn = read-host 'Enter its number. Default = 1'
            $num=1
            If (-not([string]::IsNullOrEmpty($answer)) )
            {
                if($numStrn -match '^\d+$')
                {
                    [int]$num = [int]($numStrn.Trim())
                    if(($num -gt $numTenants) -or ( $num -lt 1))
                    {
                        $num=1
                    }
                }
            }                          
            $var = $tl[$num+1]
            $z = $var -split ' '
            $TenantName = $z[1]
            $Tenant=$z[0]
            azsphere tenant select --tenantid $Tenant
            $global:Tenant= $Tenant
            $global:TenantName = $TenantName

        }
    }

    # show-heading '  A Z U R E  S P H E R E  '  3 'Connect Via IoT Hub and DPS - Get DPS ID Scope' 
    write-Host ''
    write-Host "Please wait: Getting DPS: $DPSName info:"
    $query = az iot dps show --name $DPSName -o json | Out-String | ConvertFrom-Json
    write-Host "DPS ID Scope:"
    foreach ($dps in $query) {
        $DPSidscope = $dps.Properties.idScope
    }
    $global:DPSidscope = $DPSidscope
    write-host "DPS ID Scope: $DPSidscope"
    get-anykey  'Continue'


    $global:DPSCertificateName = "cert-$global:groupname-$global:hubname-$global:dpsname"
    create-azsphere $global:subscription $global:groupname $global:hubname $global:dpsname  $global:DPSCertificateName 
    $global:EnrollmentGroup = "enrolGroup-$global:DPSCertificateName"
    create-enrolmentgroup $global:subscription $global:groupname $global:hubname $global:dpsname $global:DPSCertificateName $global:EnrollmentGroup

    
    write-app_manifest $global:DPSidscope $HubName $global:Tenant

    $global:azspheresummary =
@"

function doall-azsphere-iothub-dps()  A Z U R E  S P H E R E  SUMMARY  
    The following were attempted if not already done:
     - Connect IoT Hub to DPS
     - Open Azsphere command prompt (PS version) and Login
     -       Get DPS ID Scope: $global:DPSidscope
         DPS Service endpoint: $global:HubName.azure-devices.net
     -             Get Tenant: $global:TenantName
     -          Get Tenant ID: $global:Tenant
     -          Certify (Name: $global:DPSCertificateName) and Verify the Tenant for DPS
     - Create EnrollmentGroup: $global:EnrollmentGroup
     - Generate app-manifest.json fie in PS folder.
       ... This is a direct replacement for the file in the Azure IoT Sample at https://github.com/Azure/azure-sphere-samples/tree/master/Samples/AzureIoT (IoT Hub modde).

"@

    show-heading ' DOAll -  A Z U R E  S P H E R E  SUMMARY '  3 'Connect Via IoT Hub and DPS - Get DPS ID Scope'
    write-host "The following were attempted if not already done:"
    write-host ' - Connect IoT Hub to DPS'
    write-host ' - Open Azsphere command prompt (PS version) and Login'
    write-host " -       Get DPS ID Scope: $global:DPSidscope"
    write-host "     DPS Service endpoint: $global:HubName.azure-devices.net"
    write-host " -             Get Tenant: $global:TenantName"
    write-host " -          Get Tenant ID: $global:Tenant"
    write-host " -          Certify (Name: $global:DPSCertificateName) and Verify the Tenant for DPS"
    write-host " - Create EnrollmentGroup: $global:EnrollmentGroup"
    write-host ' - Generate app-manifest.json fie in PS folder for AzSphere Azure IoT App.\r\nThis is a direct replacement for the file in the Azure IoT Sample at https://github.com/Azure/azure-sphere-samples/tree/master/Samples/AzureIoT (IoT Hub modde).'
    get-anykey
    
    
}