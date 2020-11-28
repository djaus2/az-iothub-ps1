
function manage-azsphereDPS-enrollment-groups{
param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$HubName = '' ,
    [string]$DPSName = '',
    [string]$Tenant='',
    [String]$TenantName='',
    [string]$EnrollmentGroupName=''
)

    $DPSCertificateName = $global:DPSCertificateName

    show-heading '  A Z U R E  S P H E R E  ' 3 'Connect Via IoT Hub' 
    $Prompt = '       Subscription :"' + $Subscription +'"'
    write-Host $Prompt
    $Prompt = '               Group :"' + $GroupName +'"'
    write-Host $Prompt
    $Prompt = '                 Hub :"' + $HubName +'"'
    write-Host $Prompt
    $Prompt = '         Current DPS :"' + $DPSName +'"'
    write-Host $Prompt
    $Prompt = '      Current Tenant :"' + $TenantName +'"'
    write-Host $Prompt
    $Prompt = '  DPSCertificateName :"' + $DPSCertificateName
    write-Host $Prompt
    $Prompt = ' EnrollmentGroupName :"' + $EnrollmentGroupName
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
        $Prompt = '        Subscription :"' + $Subscription +'"'
        write-Host $Prompt
        $Prompt = '               Group :"' + $GroupName +'"'
        write-Host $Prompt
        $Prompt = '                 Hub :"' + $HubName +'"'
        write-Host $Prompt
        $Prompt = '                 DPS :"' + $DPSName +'"'
        write-Host $Prompt
        write-host ' -------------------------------------- '
        $Prompt = '         Tenant Name :"' + $TenantName +'"'
        write-Host $Prompt
        $Prompt = '              Tenant :"' + $Tenant +'"'
        write-Host $Prompt
        $Prompt = '        DPS ID Scope :"' + $DPSIdScope +'"'
        write-Host $Prompt
        $Prompt = '    IoT Hub DNS Name :"' + $HubName + '.azure-devices.net'
        write-Host $Prompt
        $Prompt = '  DPSCertificateName :"' + $DPSCertificateName +'"'
        write-Host $Prompt
        $Prompt = ' EnrollmentGroupName :"' + $EnrollmentGroupName
        write-Host $Prompt
   
        $options =",L. List and select one of the Enrollment Groups,S. Show Enrollment Group,N. Set Enrollment GroupName Name,X. Clear Enrollment GroupName Name,R. Delete Enrollment Group"

        $options="$options,B. Back"

        $answer = parse-shortlist 'EMPTY'   '   A Z U R E  S P H E R E  - MANAGE DPS ENROLLMENT GROUPS  '  $options $DPSStrnIndex $DPSStrnIndex 2  22 $Current $true
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

                        $answer = get-name 'DPS Enrollment Group Name'
                        if ($answer-eq 'Back')
                        {

                        }
                        else
                        {
                            $EnrollmentGroupName = $answer
                            $global:EnrollmentGroupName = $EnrollmentGroupName
                        }
                    
                    }
                'L' { 
                        write-host "Please wait. Getting Enrollment Groups."
                        $x = az iot dps enrollment-group list --dps-name $global:dpsname --resource-group $global:groupname -o json | ConvertFrom-Json
                        $n = $x.length
                        if ($n -ne 0)
                        {
                            # $z = $x.value | Select name
                            $list =''
                            foreach ($v in $x)
                            {
                                $name = $v.enrollmentGroupId
                                $list += $name + ','
                            }
                            $res = choose-selection $list '  A Z U R E  S P H E R E  DPS ENROLLMENT GROUPs  ' $EnrollmentGroupName
                            $res = $global:retVal
                            If (-not ([string]::IsNullOrEmpty($res )))
                            {
                                if (-not ($res -eq 'Back'))
                                {
                                    $EnrollmentGroupName= $res
                                    $global:EnrollmentGroupName = $EnrollmentGroupName
                                }
                                else {
                                    write-host "No enrollment group selected"
                                    get-anykey
                                }
                            }
                            else {
                                write-host "No enrollment group selected"
                                get-anykey
                            }
                        }
                        else {
                            write-host "No Enrollment Groups."
                            get-anykey
                        }
                    }
                'S' {
                    If (-not ([string]::IsNullOrEmpty($global:EnrollmentGroupName )))
                    {
                        write-host "Please wait. Getting Enrollment Group info."
                        az iot dps enrollment-group show --dps-name $global:dpsname --resource-group $global:groupname  --enrollment-id $EnrollmentGroupName -o jsonc
                        get-anykey
                    }
                    else 
                    {
                        write-host "No DPS Certicate name."
                        get-anykey
                    }
                }
                'X' {
                        If (-not([string]::IsNullOrEmpty($global:EnrollmentGroupName )))
                        {
                            $EnrollmentGroupName = ''
                            $global:EnrollmentGroupName = $EnrollmentGroupName
                        }
                    }
                'R' {
                        If (-not ([string]::IsNullOrEmpty($global:EnrollmentGroupName )))
                        {
                            write-host "Please wait.  Getting Enrollment Group info.."
                            $engroup = az iot dps enrollment-group show --dps-name $global:dpsname --resource-group $global:groupname  --enrollment-id $EnrollmentGroupName -o json | Out-String
                            If (-not ([string]::IsNullOrEmpty($engroup )))
                            {      
                                # Assume if $engroup is non blank that the group exists                        
                                write-host "Please wait. Deleting Enrollment Group"
                                az iot dps enrollment-group delete --dps-name $global:dpsname  --resource-group $global:groupname  --enrollment-id $EnrollmentGroupName
                                $EnrollmentGroupName = ''
                                $global:DPSCertificateName = $EnrollmentGroupName = ''

                                get-anykey 'Done' 'Press any key to continue'
                            }
                            else{
                                write-host "Enrollment Group not found."
                                get-anykey
                            }
                        }
                        else 
                        {
                            write-host "No DPS Enrollment Group Name."
                            get-anykey
                        }
                    }

            }
        }
    } while (($answer -ne 'Back') -and ($answer -ne 'Error'))

    $global:retval = $answer
}
