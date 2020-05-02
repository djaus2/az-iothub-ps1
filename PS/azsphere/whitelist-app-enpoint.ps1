function whitelist-iotcentralapp{
param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$IoTCentralName = '' 
)

    show-heading '  A Z U R E  S P H E R E  ' 3 'Connect Via IoT Central - Whitelist' 
    $Prompt = '     Subscription :"' + $Subscription +'"'
    write-Host $Prompt
    $Prompt = '            Group :"' + $GroupName +'"'
    write-host ' ------------------------------------ '
    $Prompt = ' IoT Central App Name :"' + $Iotcentralname +'"'
    write-Host $Prompt
    $Prompt = '  IoT Central App URL :"' + $Iotcentralname.azureiotcentral.com +'"'
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
    elseIf ([string]::IsNullOrEmpty($IoTCentralName ))
    {
        write-Host ''
        $prompt = 'Need to get IoT Central App  first.'
        write-host $prompt
        get-anykey 
        return
    }   

    $prompt = 'Openning IoT Central app: $IoTCentralName'
    write-host $prompt
    $url = "$Iotcentralname.azureiotcentral.com"
    start-process  $url
    get-anykey '' 'Continue when app is open'
    get-anykey '' 'Show screenshot of what to do next'
    show-image 'create-azapp.png' 'Configure Azure Sphere Learning Path Azure IoT App' ''

    return
}