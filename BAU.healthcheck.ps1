###--- check the server status ---###
Get-Brokermachine -SessionSupport MultiSession |select CatalogName, DNSName, ImageOutOfDate, InMaintenanceMode, IsAssigned, LoadIndex, SessionCount |Format-table -AutoSize


###--- check the server status ---###

