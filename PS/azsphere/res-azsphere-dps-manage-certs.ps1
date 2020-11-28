
function manage-azsphereDPS-certs{
param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$DPSName = '',
    [string]$Tenant='',
    [String]$TenantName=''
)

    $DPSCertificateName = $global:DPSCertificateName

    show-heading '  A Z U R E  S P H E R E  ' 3 'Connect Via IoT Hub' 
    $Prompt = '   Subscription :"' + $Subscription +'"'
    write-Host $Prompt
    $Prompt = '          Group :"' + $GroupName +'"'
    write-Host $Prompt
    $Prompt = '            Hub :"' + $HubName +'"'
    write-Host $Prompt
    $Prompt = '    Current DPS :"' + $DPSName +'"'
    write-Host $Prompt
    $Prompt = ' Current Tenant :"' + $TenantName +'"'
    write-Host $Prompt
    $Prompt = ' DPSCertificateName :"' + $DPSCertificateName
    write-Host $Prompt

 

    If ([string]::IsNullOrEmpty($Subscription ))
    {
        write-Host ''
        $prompt =  'Need to select a Subscription first.'
        write-host $prompt
        get-anykey 
        $global:DPS =  'Back'
        return
    }
    elseIf ([string]::IsNullOrEmpty($GroupName ))
    {
        write-Host ''
        $prompt = 'Need to select a Group first.'
        write-host $prompt
        get-anykey 
        $global:DPS =  'Back'
        return
    }
    elseIf ([string]::IsNullOrEmpty($HubName ))
    {
        write-Host ''
        $prompt = 'Need to select a Hub first.'
        write-host $prompt
        get-anykey 
        $global:DPS =  'Back'
        return
    }
    elseIf ([string]::IsNullOrEmpty($DPsName ))
    {
        write-Host ''
        $prompt = 'Need to select a DPS first.'
        write-host $prompt
        get-anykey 
        $global:DPS =  'Back'
        return
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


  
    $DPSidscope=$global:DPSidscope

    $DPSStrnIndex =3
    $DPSStrnDataIndex =5


    do{

        if ($Refresh -eq $true)
        {
            $Refresh=$false
        }


        show-heading '  A Z U R E  S P H E R E  '  3 'Connect Via IoT Hub and DPS' 
        $Prompt = '       Subscription :"' + $Subscription +'"'
        write-Host $Prompt
        $Prompt = '              Group :"' + $GroupName +'"'
        write-Host $Prompt
        $Prompt = '                Hub :"' + $HubName +'"'
        write-Host $Prompt
        $Prompt = '                DPS :"' + $DPSName +'"'
        write-Host $Prompt
        write-host ' -------------------------------------- '
        $Prompt = '        Tenant Name :"' + $TenantName +'"'
        write-Host $Prompt
        $Prompt = '             Tenant :"' + $Tenant +'"'
        write-Host $Prompt
        $Prompt = '       DPS ID Scope :"' + $DPSIdScope +'"'
        write-Host $Prompt
        $Prompt = '   IoT Hub DNS Name :"' + $HubName + '.azure-devices.net'
        write-Host $Prompt
        $Prompt = ' DPSCertificateName :"' + $DPSCertificateName +'"'
        write-Host $Prompt


        $options =",L. List and select one of the DPS's Certificates,S. Show Certifcate,N. Set DPS Certificate Name,,X. Clear DPS Certificate Name,R. Delete DPS Certificate"
        $options="$options,B. Back"

        $answer = parse-shortlist 'EMPTY'   '   A Z U R E  S P H E R E  - MANAGE DPS CERTS  '  $options $DPSStrnIndex $DPSStrnIndex 2  22 $Current $true
        $answer= $global:retVal

        If ([string]::IsNullOrEmpty($answer)) 
        {
            write-Host 'Back'
            $answer = 'Back'
        }
        elseif ($answer-eq 'Back')
        {
            write-Host 'Back'
        }
        elseif ($answer-eq 'Error')
        {
            write-Host 'Error'
        }
        else {
            
            $kk2 = [char]::ToUpper($global:kk)
            $global:kk = $null
            switch ($kk2)
            {

                'N' {

                        $answer = get-name 'DPS Certificate Name'
                        if ($answer-eq 'Back')
                        {

                        }
                        else
                        {
                            $DPSCertificateName = $answer
                            $global:DPSCertificateName = $DPSCertificateName
                        }
                    
                    }
                'L' { 
                        write-host "Please wait. Getting Certificates."
                        $x = az iot dps certificate list --dps-name $global:dpsname  --resource-group $global:groupname -o json | ConvertFrom-Json
                        $n = $x.value.length
                        if ($n -ne 0)
                        {
                            # $z = $x.value | Select name
                            $list =''
                            foreach ($v in $x.value)
                            {
                                $name = $v.name
                                $list += $name + ','
                            }
                            $res = choose-selection $list '  A Z U R E  S P H E R E  DPS Certificates  ' $DPSCertificateName
                            $res = $global:retVal
                            If (-not ([string]::IsNullOrEmpty($res )))
                            {
                                if (-not ($res -eq 'Back'))
                                {
                                    $DPSCertificateName= $res
                                    $global:DPSCertificateName = $DPSCertificateName
                                }
                                else {
                                    write-host "No certificate selected 2."
                                    get-anykey
                                }
                            }
                            else {
                                write-host "No certificate selected 1."
                                get-anykey
                            }
                        }
                        else {
                            write-host "No certificates."
                            get-anykey
                        }
                    }
                'S' {
                    If (-not ([string]::IsNullOrEmpty($global:DPSCertificateName )))
                    {
                        write-host "Please wait. Getting certificate info."
                        az iot dps certificate show --dps-name $global:dpsname --resource-group $global:groupname --certificate-name $global:DPSCertificateName -o jsonc
                        get-anykey
                    }
                    else 
                    {
                        write-host "No DPS Certicate name."
                        get-anykey
                    }
                }
                'X' {
                        If (-not([string]::IsNullOrEmpty($global:DPSCertificateName )))
                        {
                            $DPSCertificateName = ''
                            $global:DPSCertificateName = $DPSCertificateName
                        }
                    }
                'R' {
                        If (-not ([string]::IsNullOrEmpty($global:DPSCertificateName )))
                        {
                            write-host "Please wait. Getting certificate info."
                            $cert = az iot dps certificate show --dps-name $global:dpsname --resource-group $global:groupname --certificate-name $global:DPSCertificateName -o tsv | Out-String
                            If (-not ([string]::IsNullOrEmpty($cert )))
                            {
                                $infos =   $cert -split '\t'
                                if ($infos.Length -gt 0)
                                {
                                    $etag = $infos[0]
                                    If (-not([string]::IsNullOrEmpty($etag )))
                                    {                                
                                        write-Host "etag: " + $etag
                                        # write-host "az iot dps certificate delete --dps-name $global:dpsname  --resource-group $global:groupname  --certificate-name $global:DPSCertificateName --etag $etag"
                                        # get-anykey
                                        write-host "Please wait. Deleting certifcate"
                                        az iot dps certificate delete --dps-name $global:dpsname  --resource-group $global:groupname  --certificate-name $global:DPSCertificateName --etag $etag
                                        $DPSCertificateName = ''
                                        $global:DPSCertificateName = $DPSCertificateName
                                        get-anykey 'Done' 'Press any key to continue'
                                    }
                                    else {
                                        write-host "Certificate etag not found."
                                        get-anykey
                                    }
                                }
                                else {
                                    write-host "Certificate not found."
                                    get-anykey
                                }
                            }
                        }
                        else 
                        {
                            write-host "No DPS Certicate name."
                            get-anykey
                        }
                    }

            }
        }
    } while (($answer -ne 'Back') -and ($answer -ne 'Error'))

    $global:retval = $answer
}
