### --- check all Patch level ---###
$ComputerName = Get-Content 'ServerlistMaster.txt'
$AllResult = @()

$StartTime=(Get-date).AddDays(-10)

$ComputerName| Foreach-object {
$PendingReboot=0
$System = Get-CimInstance -ComputerName $_ -Class win32_operatingsystem
$Hotfix = Get-hotfix  -computername $_  |where-object {$_.installedOn -gt $starttime}
$CitrixService = Get-Service  -computername $_ -DisplayName Citrix* |where-object {$_.status -ne "Running"}

$reg=Invoke-Command -Computer $_ -ScriptBlock {
get-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" -Name AUOptions -ErrorAction Ignore
get-ItemProperty  -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing" -Name RebootPending  -ErrorAction Ignore
get-ItemProperty  -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing" -Name RebootPending  -ErrorAction Ignore 
get-ItemProperty  -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing" -Name PackagesPending -ErrorAction Ignore
get-ItemProperty  -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing" -Name RebootInProgress -ErrorAction Ignore
get-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" -Name RebootRequired -ErrorAction Ignore
get-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" -Name PostRebootReporting -ErrorAction Ignore
get-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services " -Name Pending -ErrorAction Ignore
}
if ($reg){
$PendingReboot=1
}

$VMInfo = [pscustomobject]@{
Name = $System.csname
PendingReboot=$PendingReboot
ServiceNotRunning = $CitrixService.Count
Lastbootuptime =$System.lastbootuptime
hotfixID =$Hotfix.HotfixID
}
# $VMInfo |Format-Table -autosize
$AllResult += $VMInfo
}

$AllResult|Format-Table -autosize
