$parameters = @{
  ComputerName = Get-Content VM_DDC_XA.txt
  ScriptBlock = {Get-Brokermachine -SessionSupport MultiSession -ProvisioningType MCS}
}

Invoke-Command @parameters |select CatalogName, DNSName, ImageOutOfDate, InMaintenanceMode, LoadIndex, SessionCount, RegistrationState |Format-table -AutoSize 

###--- check the Xenapp status ---###
