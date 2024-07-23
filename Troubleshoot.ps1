$ComputerName =  ""

$AllCR= $ComputerName |ForEach {
###----- Collect last changed KB/ SW -----# 
(Get-HotFix -ComputerName  $_ | Sort-Object InstalledOn|select InstalledOn, CSName, HotfixID)[-1] |ft

$SW=Get-CimInstance -ComputerName $_ -Class Win32_Product
($SW |Sort-Object InstallDate |select InstallDate, Name , Vendor,  Version)[-1] |ft

###----- Collect last reboot time. -----# 
$SystemInfo =Get-CimInstance  -ComputerName $_ -Class win32_operatingsystem
$SystemInfo |select lastbootuptime  |ft


###--- select all non-started Citrix service --- ###

}
$AllCR


#----- Collect all log from server group in last 1 days-----# 
$StartTime=(Get-date).AddDays(-1)
$EndTime= Get-date

$Error=$ComputerName |foreach {
Get-WinEvent -ComputerName $_ -FilterHashTable @{level=2;LogName="system";StartTime=$StartTime;EndTime=$EndTime}
Get-WinEvent -ComputerName $_ -FilterHashTable @{level=2;LogName="application";StartTime=$StartTime;EndTime=$EndTime}
}

$Error |select timecreated, MachineName, Message |sort timecreated




### --- --- ###

