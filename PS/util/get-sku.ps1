function get-sku
{
    write-host ''
    $prompt =  "IoT Hub SKUs Ref: https://azure.microsoft.com/en-us/pricing/details/iot-hub/"
    write-host  $prompt
    write-host ''
    #Need an SKU
    $skus = 'B1,B2,B3,F1,S1,S2,S3'
    if ([string]::IsNullOrEmpty($SKU))
    {

        $answer = choose-selection $skus 'SKU' $DefaultSKU
        # $answer = $global:retVal

        if ([string]::IsNullOrEmpty($answer))
        {
            $global:retVal = 'Back'
            return
        }
        elseif  ($answer -eq 'Back')
        {
            $global:retVal = 'Back'
            return
        }

        $SKU = $answer
    }
    $global:SKU = $SKU
    return $SKU
}