$parameters = @{
  ComputerName = Get-Content VM_DDC.txt
  ScriptBlock = {Get-Brokermachine -ProvisioningType MCS}
}

Invoke-Command @parameters |select DNSName |export-csv output_VM_MCS.txt

$ComputerNameMCS = Import-csv output_VM_MCS.txt -Header MCSserver
Get-CimInstance -ComputerName $ComputerNameMCS.MCSserver -Class win32_operatingsystem | select csname, lastbootuptime |Sort-Object lastbootuptime|out-file output_bootuptime.txt
