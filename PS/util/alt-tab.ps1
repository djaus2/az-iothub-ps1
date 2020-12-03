 # Ref: https://stackoverflow.com/questions/54999200/send-keys-in-powershell-altn-tab-enter  
Add-Type -AssemblyName System.Windows.Forms
function do-alttab{
param (
    [int]$num = 1
)
    for ($i=0;$i -lt $num;$i++)
    {
        [System.Windows.Forms.SendKeys]::SendWait("%{TAB}{ENTER}")
    }
}
#Test:
#do-alttab 3
    