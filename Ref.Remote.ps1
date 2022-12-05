###--- sample of remote execute ---###

$ComputerName = "serverA`r`nServerB`r`nServerC"
$computerName |out-file serverlist.txt

$parameters = @{
  ComputerName = Get-Content serverlist.txt
  ScriptBlock = {Get-BrokerMachine -OSType "Windows 10" -filter {IsAssigned -eq $true} -MaxRecordCount 10000|measure-object  }
}
Invoke-Command @parameters |export-csv "Uniq VDI users.txt"

###--- sample of remote execute ---###

#Invoke-Command @parameters | Select-Object name, AllAssociatedDesktopGroupUUIDs, UserFilterEnabled, @{l="AssociatedUserNames";e={$_.AssociatedUserNames -join ","}} |export-csv EnabledApplication.csv
