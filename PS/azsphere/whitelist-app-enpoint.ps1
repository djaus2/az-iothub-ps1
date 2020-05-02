function whitelist-iotcentralapp{
param (
    [string]$Subscription = '' ,
    [string]$GroupName = '' ,
    [string]$IoTCentralName = '',
    [string]$IoTCentralURL=''
)

    show-heading '  A Z U R E  S P H E R E  ' 3 'Connect Via IoT Central - Whitelist' 
    $Prompt = '          Subscription :"' + $Subscription +'"'
    write-Host $Prompt
    $Prompt = '                 Group :"' + $GroupName +'"'
    write-host ' ------------------------------------ '
    $Prompt = '  IoT Central App Name :"' + $Iotcentralname +'"'
    write-Host $Prompt
    $Prompt = '   IoT Central App URL :"' + $IotcentralURL+'"'
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
        $prompt = 'Need to get IoT Central App Name  first.'
        write-host $prompt
        get-anykey 
        return
    }  
    elseIf ([string]::IsNullOrEmpty($IoTCentralURL ))
    {
        write-Host ''
        $prompt = 'Need to get IoT Central App  URL.'
        write-host $prompt
        get-anykey 
        return
    }   

    $prompt = "Openning IoT Central app: $IoTCentralName"
    write-host $prompt
    read-host $IoTCentralURL
    $url = "https://$IoTCentralURL"
    start-process  $url
    get-anykey '' 'Continue when app is open'
    get-anykey '' 'Show 3 screenshots of what to do next'
    show-image 'whitelist-1.png' 'Configure Azure Sphere Learning Path Azure IoT App' ''
    show-image 'whitelist-2.png' 'Configure Azure Sphere Learning Path Azure IoT App' ''
    show-image 'whitelist-3.png' 'Configure Azure Sphere Learning Path Azure IoT App' ''

    show-image 'whitelist-4.png' 'Configure Azure Sphere Learning Path Azure IoT App' ''
    $global:IDScope = get-clipboard -format text
    
    get-anykey '' 'show the IoT Central Info page. Return here when open.'   
    $url = "https://azuredps.z23.web.core.windows.net"
    start-process  $url



    show-image 'whitelist-5.png' 'Configure Azure Sphere Learning Path Azure IoT App' ''  
    $global:DevURL=get-clipboard -format text





    return
}