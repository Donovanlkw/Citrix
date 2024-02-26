#----- Collect all log from server group in last n days-----# 
$ComputerName = Get-Content serverlist.txt
$computername =$env:COMPUTERNAME
$n="4"
$LogName="Application"
$level = "2" 
#level 2 = Error. , level 3 = Warining. 

$StartTime=(Get-date).AddDays(-$n)
$EndTime= Get-date
ForEach ($Server in $Computername) {
$Log=Get-WinEvent -ComputerName $server -FilterHashTable @{level=$level;LogName=$LogName;StartTime=$StartTime;EndTime=$EndTime}
$logoutput =$Log|select MachineName, LogName, Providername,id,TimeCreated,Message |format-table
}
# $rpm= Get-eventlog -logname system -source rpm -after 1/20/2024 
