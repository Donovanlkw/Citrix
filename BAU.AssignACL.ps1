###--- Enquiry assoicatd user of each VM  --- ###

$parameters = @{
  ComputerName = Get-Content VM_DDC.txt
  ScriptBlock = {Get-BrokerDesktop   -MaxRecordCount 10000 }
}

Invoke-Command @parameters |Select-Object MachineName, @{l="AssociatedUserNames";e={$_.AssociatedUserNames -join ","}} |Export-Csv "$computer.Userlist.csv"

#Consolidate all the Inventory files.
Get-ChildItem -include azaw* -Recurse |get-content|Out-File StudioInventory -NoClobber

####--- #Get the VM Inventory from Citrix Studio --- ####
