###--- check the Xenapp status ---###

$ComputerName = "serverA`r`nServerB`r`nServerC"
$computerName |out-file serverlist.txt

$parameters = @{
  ComputerName = Get-Content serverlist.txt
  ScriptBlock = {Get-Brokermachine -SessionSupport MultiSession}
}
Invoke-Command @parameters |select CatalogName, DNSName, ImageOutOfDate, InMaintenanceMode, IsAssigned, LoadIndex, SessionCount |Format-table -AutoSize

###--- check the Xenapp status ---###
