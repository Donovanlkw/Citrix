
#----- Collect CCC HA Mode change ? in last 1 days-----# 
$StartTime=(Get-date).AddDays(-1)
$EndTime= Get-date
$LogName="Application"
$eventid="3003"
$ProviderName="Citrix Remote Broker Provider"

$CCClog=$ComputerName|Foreach {
Get-WinEvent -ComputerName $_ -FilterHashTable @{LogName=$LogName;ProviderName=$ProviderName;Id=$eventid;StartTime=$StartTime;EndTime=$EndTime}
}

$CCClog |SELECT MachineName, Timecreated, Message

###--- https://docs.citrix.com/en-us/citrix-daas/manage-deployment/local-host-cache.html


