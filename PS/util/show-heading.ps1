function show-heading{
param (
   [Parameter(Mandatory)]
   [string]$Prompt ,
   [Parameter(Mandatory)]
   $Level
)
    $fg="White"
    $bg="blue"
    switch ($level){
        1 { 
            $fg=$headingfgColor_1
            $bg=$headingbgColor_1
        }
        2 { 
            $fg=$headingfgColor_2
            $bg=$headingbgColor_2
        }
        3 { 
            $fg=$headingfgColor_3
            $bg=$headingbgColor_3
        }
        4 { 
            $fg=$headingfgColor_4
            $bg=$headingbgColor_4
        }
    }

    [Console]::ResetColor()
    If  ([string]::IsNullOrEmpty($env:LogAzIoTPS)) 
    {
        Clear-Host
    }
    $prompt2 =  '  A Z U R E  I o T  H U B  ' 
    write-Host $prompt2 -BackgroundColor Red  -ForegroundColor   White  -NoNewline
    [Console]::ResetColor()
    write-Host ' '  -NoNewline
    write-Host $prompt -BackgroundColor $bg -ForegroundColor $fg -NoNewline
    [Console]::ResetColor()
    write-Host ' using PowerShell AND Azure CLI'
    write-Host ''
}
