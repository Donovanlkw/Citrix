$ComputerName="localhost"

$computerName|out-file "serverlist.txt"
# -Encoding unicode

$parameters = @{
  ComputerName = Get-Content "serverlist.txt"
  ScriptBlock = {Get-BrokerDesktopGroup -filter {Enabled -eq "True"}  | ForEach-Object {
Get-BrokerApplication -AllAssociatedDesktopGroupUUID $_.UUID.guid -filter {Enabled -eq "True"}  
     } 
  }
}
Invoke-Command @parameters | Select-Object name, AllAssociatedDesktopGroupUUIDs, UserFilterEnabled, @{l="AssociatedUserNames";e={$_.AssociatedUserNames -join ","}} |export-csv EnabledApplication.csv
