###--- sample of remote execute ---###

$ComputerName = "serverA`r`nServerB`r`nServerC"
$computerName |out-file serverlist.txt

$parameters = @{
  ComputerName = Get-Content serverlist.txt
  ScriptBlock = {Get-BrokerMachine -OSType "Windows 10" -filter {IsAssigned -eq $true} -MaxRecordCount 10000|measure-object
  #Pass-through variable
  write-host $using:computername
  
  
  }
}
Invoke-Command @parameters |export-csv "Uniq VDI users.txt"
