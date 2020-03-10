function start-time{
    # Ref: https://stackoverflow.com/questions/10941756/powershell-show-elapsed-time
    $global:Time = [System.Diagnostics.Stopwatch]::StartNew()
}

function show-time{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $prompt =' elapsed'
    )
    If (-not([string]::IsNullOrEmpty($global:Time )))
    {
        $CurrentTime = $Time.Elapsed
        write-host $([string]::Format(" `rTime: {0:d2}:{1:d2}:{2:d2} ",
        $CurrentTime.hours,
        $CurrentTime.minutes,
        $CurrentTime.seconds)) -nonewline -BackgroundColor Yellow  -ForegroundColor   Black  -NoNewline
        write-host " $prompt "
    }
}

function stop-time{
    If (-not([string]::IsNullOrEmpty($global:Time )))
    {
        remove-variable Time  -Scope Global
    }
}