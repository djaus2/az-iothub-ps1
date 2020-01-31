function clear-env{
    $env:IOTHUB_DEVICE_CONN_STRING = $null
    $env:REMOTE_HOST_NAME = $null
    $env:REMOTE_PORT = $null
    $env:IOTHUB_CONN_STRING_CSHARP = $null
    $env:DEVICE_ID = $null
}

function set-env{
    $env:IOTHUB_DEVICE_CONN_STRING = "AAA"
    $env:REMOTE_HOST_NAME = "BBB"
    $env:REMOTE_PORT = "CCC"
    $env:IOTHUB_CONN_STRING_CSHARP ="DDD"
    $env:DEVICE_ID = "EEE"
}