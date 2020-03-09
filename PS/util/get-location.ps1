function get-location
{
    # Need a location
    # Get list from Azure
    if ([string]::IsNullOrEmpty($global:Location))
    {
        if ([string]::IsNullOrEmpty($global:LocationsStrn))
        {
            $global:LocationsStrn = az account list-locations  -o tsv | Out-String
        }
        if ([string]::IsNullOrEmpty($global:LocationsStrn))
        {
            $prompt = 'Error getting Resource Group Location List.'
            $global:retVal = 'Error'
            get-anykey $prompt 'Exit'
            return
        }
        parse-list $global:LocationsStrn  '  L O C A T I O N  ' 'B. Back'   $LocationStrnIndex $LocationStrnDataIndex 3  36  $DefaultRegion
        
        $result = $global:retVal

        $prompt = 'Location "' + $result +'" returned'
        write-Host $prompt

        if ([string]::IsNullOrEmpty($result))
        {
            $global:retVal = 'Back'
            return
        }
        elseif ($result -eq 'Back')
        {
            $global:retVal = 'Back'
            return
        }
        elseif ($result -eq 'Error')
        {
            $global:retVal = 'Error'
            return
        }
        elseif ($result -eq 'Exit')
        {
            $global:retVal ='Exit'
            return
        }
        $Location = $result
        $global:retVal = $location
        return $location
    }
    else {
        $global:retVal = $global:location
        return $global:location
    }
}