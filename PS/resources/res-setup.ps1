function install-download{
param (
[Parameter(Mandatory)]
[string]$URL, 
[Parameter(Mandatory)]
[string]$Output
)

    if (Test-Path $output)
    {
        If  ([string]::IsNullOrEmpty($global:usePreviousDownloads)) {
        Remove-Item -path $output
        write-host  "Downloading installer from $url to: $output" 
        get-anykey '' 'Continue'
        write-host "Please wait"
        Import-Module BitsTransfer
        Start-BitsTransfer -Source $url -Destination $output
        } else{
            write-host 'Using previous download. N.B. $global:usePreviousDownloads impacts this. If clear will download anyway.'
        }
    }
    else {
        write-host  "Downloading installer from $url to: $output" 
        get-anykey '' 'Continue'
        write-host "Please wait"
        Import-Module BitsTransfer
        Start-BitsTransfer -Source $url -Destination $output
    }
    if (Test-Path $output)
    {
        write-host 'Download complete. Do installation.' 
        get-anykey '' 'Continue'
        Start-Process  $output -Wait
        write-host 'Done'
        get-anykey
    }
    else{
        write-host 'Download failed'
        get-anykey
    }
    if (Test-Path $output)
    {
        write-host "Nb: Download is still there: $output"
        get-anykey
    }
}

function do-setup{

    $options = 'A. Install Azure Cli using PowerShell,L. Az Cli Login,E. Install Az IOT Extension,U. Update Az IoT Extensions,R. Remove Az IOT Extensions,V. Azure CLI Version and info,Z. Install Azure Sphere SDK'

    $options="$options,B. Back"
    do{
        $res = parse-list 'EMPTY'   ' A z  C L I  S E T U P   ' $options  $DeviceStrnIndex $DeviceStrnDataIndex 1  22 $Current
        $answer =  $global:retVal
        $kk = $global:kk

        if ([string]::IsNullOrEmpty($answer)) 
        {
            write-Host 'Back'
            $answer =  'Back'
        }
        elseIf ($answer -eq 'Error'){}
        else 
        {
            switch ($kk)
            {
                A {
                    $url="https://aka.ms/installazurecliwindows"
                    $output = "$global:ScriptDirectory\temp\azure-cli.msi"
                    install-download $url $output 
                  }
                L {
                    write-host "Please wait. A browser will show for login."
                    az login
                    get-anykey
                }
                V {
                    write-host "Please wait"
                    az --version
                    get-anykey
                }
                E {     
                    write-host "Please wait"             
                    az extension add --name azure-iot 
                    write-host "Ref https://github.com/azure/azure-iot-cli-extension"
                    get-anykey
                }
                U {
                    write-host "Please wait"
                    az extension update --name azure-iot 
                    write-host "Ref https://github.com/azure/azure-iot-cli-extension"
                    get-anykey      
                }
                R {
                    write-host "Please wait"
                    az extension remove --name azure-iot
                    write-host "Ref https://github.com/azure/azure-iot-cli-extension"
                    get-anykey
                }
                z{
                    $url="https://aka.ms/AzureSphereSDKDownload"
                    $output="$global:ScriptDirectory\install-azsphere.exe"
                    install-download $url $output                
                }
            }
        }
    } while (($answer -ne 'Back') -and ($answer -ne 'Error'))
}
