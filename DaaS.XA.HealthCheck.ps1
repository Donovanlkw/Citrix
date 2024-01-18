###--- check the Xenapp status ---###

$parameters = @{
  ComputerName = Get-Content "VM_DDC_XA.txt"
  ScriptBlock = {Get-Brokermachine -SessionSupport MultiSession -ProvisioningType MCS}
}

$result = Invoke-Command @parameters
$result |select CatalogName, DNSName, ImageOutOfDate, InMaintenanceMode, LoadIndex, SessionCount, RegistrationState |Sort-Object sessionCount, LoadIndex |Format-table -AutoSize 
