# Authentication
$webclient = New-Object System.Net.WebClient
$creds = New-Object System.Net.NetworkCredential("login","pwd");
$webclient.Credentials = $creds

# Data prep
# $data = @{Name='Test';} | ConvertTo-Json
$url="https://appsubdomain.azureiotcentral.com/api/preview/apiTokens"
# $url='https://apps.azureiotcentral.com/api/preview/applications'
# GET
$webClient.DownloadString($url) | ConvertFrom-Json

# POST
#$webClient.UploadString($url,'POST',$data)

# PUT
#$webClient.UploadString($url,'PUT',$data)
