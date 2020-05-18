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
<#
    write-host 'Please wait. Connecting IoTHub and DPS in Azure.'
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
    get-anykey '' 'Continue'
    #>

    create-azsphere $global:subscription $global:groupname $global:hubname $global:dpsname  "$global:groupname-$global:hubname-$global:dpsname"
}