###--- check the Xenapp status ---###


$computer = "DDC"
Invoke-Command -Computer $computer -ScriptBlock {
	Get-Brokermachine -SessionSupport MultiSession
 } |	select CatalogName, DNSName, ImageOutOfDate, InMaintenanceMode, IsAssigned, LoadIndex, SessionCount |Format-table -AutoSize


Get-Brokermachine -SessionSupport MultiSession |select CatalogName, DNSName, ImageOutOfDate, InMaintenanceMode, IsAssigned, LoadIndex, SessionCount |Format-table -AutoSize


###--- check the server status ---###

