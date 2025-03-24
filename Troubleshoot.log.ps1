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

#----- Collect all log from server group in last n days-----# 

### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- 

#----- Get the RDS Logon in last 7 days-----# 
$StartTime=(Get-date).AddDays(-7)
$EndTime= Get-date
$LogName="Security"
$eventid="4624"
$hostname=$env:computername


$Winevent=Get-WinEvent -ComputerName $hostname -FilterHashTable @{LogName=$LogName;ID=$eventid;StartTime=$StartTime;EndTime=$EndTime} 
$Events =$winevent | ?{$_.Message -match 'logon type:\s+(10)\s'}| ForEach-Object {
    $Values = $_.Properties | ForEach-Object { $_.Value }
    
    # return a new object with the required information
    [PSCustomObject]@{
        Time      = $_.TimeCreated
        # index 0 contains the name of the update
        Event     = $Values[0]
	UserID	= $Values[5]
    }
}

$Events | Format-Table -AutoSize

################ Event Log ################
################ Date ################  
$StartTime=Get-Date -Year 2019 -Month 11 -Day 1 -Hour 00 -Minute 00
$EndTime=Get-Date -Year 2020 -Month 11 -Day 1 -Hour 00 -Minute 00
$hostname="vwts19bk-easd12"


$LogName="Application"
$FileName="Application"
$GE2=Get-WinEvent   -ComputerName $hostname -FilterHashtable @{LogName=$LogName;Level='2';StartTime=$StartTime;EndTime=$EndTime}  -MaxEvents  100
$GE2 | export-csv "$hostname-$FileName-2.csv"
$GE3=Get-WinEvent   -ComputerName $hostname -FilterHashtable @{LogName=$LogName;Level='3';StartTime=$StartTime;EndTime=$EndTime}  -MaxEvents  100
$GE3 | export-csv "$hostname-$FileName-3.csv"


$LogName="Microsoft-Windows-RemoteDesktopServices-RdpCoreTS/Operational"
$FileName="Microsoft-Windows-RemoteDesktopServices-RdpCoreTS"

$GE2=Get-WinEvent   -ComputerName $hostname -FilterHashtable @{LogName=$LogName;Level='2';StartTime=$StartTime;EndTime=$EndTime}  -MaxEvents  100
$GE2 | export-csv "$hostname-$FileName-2.csv"
$GE3=Get-WinEvent   -ComputerName $hostname -FilterHashtable @{LogName=$LogName;Level='3';StartTime=$StartTime;EndTime=$EndTime}  -MaxEvents  100
$GE3 | export-csv "$hostname-$FileName-3.csv"

