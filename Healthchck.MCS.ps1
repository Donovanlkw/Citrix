$ComputerName=""
$computerName |out-file serverlistDDC.txt

$parameters = @{
  ComputerName = Get-Content serverlistDDC.txt
  ScriptBlock = {Get-ProvScheme |where {$_.machinecount -gt 0} }
}

Invoke-Command @parameters |select IdentityPoolName, MasterImageVM | export-csv MCSimage.csv
