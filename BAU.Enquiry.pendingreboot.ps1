#Check server reboot pending reboot

Invoke-Command -Computer  (get-content $pwd\serverlist.txt)  -ScriptBlock {

$Pendingreboot1 = test-path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending'
$Pendingreboot2 = test-path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootInPendingrebootogress'
$Pendingreboot3 = test-path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired'
$Pendingreboot4 = test-path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\PackagesPending'
$Pendingreboot5 = test-path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\PostRebootReporting'
$Pendingreboot = "$env:computername","$Pendingreboot1","$Pendingreboot2","$Pendingreboot3","$Pendingreboot4","$Pendingreboot5"
$PRTable= $Pendingreboot -join ","
$PRTable 
} |Out-File $pwd\rebootpending.txt
