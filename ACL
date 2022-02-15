#Get the VM Inventory from Citrix Studio

$computer = "DDC"
Invoke-Command -Computer $computer -ScriptBlock {
	Get-BrokerDesktop   -MaxRecordCount 10000 
 } |	Select-Object MachineName, @{l="AssociatedUserNames";e={$_.AssociatedUserNames -join ","}} |Export-Csv $computer
 
# Merge all the files
Get-ChildItem -include azaw* -Recurse |get-content|Out-File StudioInventory -NoClobber
