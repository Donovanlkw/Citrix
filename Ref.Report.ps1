### --- this is the sample of creating a custome report ---###
$ComputerName = @{}
$ComputerName = $VM_core_JPE_JPW
$AllResult = @()
$StartTime=(Get-date).AddDays(-7)

$ComputerName| Foreach-object {
$PendingReboot=0
$System = Get-CimInstance -ComputerName $_ -Class win32_operatingsystem
$Hotfix = Get-hotfix  -ComputerName $_ |where-object {$_.installedOn -gt $starttime}
$CitrixService = Get-Service  -ComputerName $_ -DisplayName Citrix* |where-object {$_.status -ne "Running"} |where-object {$_.StartType  -ne "disabled" }

$reg=Invoke-Command -Computer $_ -ScriptBlock {
###--- https://batchpatch.com/explanation-of-get-pending-reboot-status-actions-in-batchpatch ---###
test-path -path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -ErrorAction Ignore
test-path -path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -ErrorAction Ignore
}
if($reg -like "True"){ 
$PendingReboot=1
}

### --- define the table as you want --- ###

$VMInfo = [pscustomobject]@{
Name = $System.csname
PendingReboot = $PendingReboot
ServiceNotRunning = $CitrixService.Count
Lastbootuptime = $System.lastbootuptime
hotfixID = $Hotfix.HotfixID
}

### --- Add each role into your report's table --- ###
$AllResult += $VMInfo
}

$AllResult|Format-Table -autosize
