<### --- Healthcheck v2  --- ###>

$reportMC =@()
$VM_DDC_XA|ForEach{
$resultMC=Get-ProvScheme -AdminAddress $_ |where {$_.machinecount -gt 0}  |sort-Object MasterImageVMDate

  $reportMC =@()
  $reportMC= for($i= 0; $i -lt $ResultMC.count; $i++) {  
    [PSCustomObject]@{
    MC= $resultMC[$i].IdentityPoolName
    ImageUpdate = $resultMC[$i].MasterImageVMDate
    Snapshot= split-path -path $resultMC[$i].MasterImageVM -leaf
    }
  }
$reportMC
}

$reportVM =@()
$VM_DDC_XA |ForEach{
$resultVM=Get-ProvVM -AdminAddress $_ |select * |sort-Object ImageOutOfDate, LastBootTime

  $reportVM =@()
  $reportVM= for($i= 0; $i -lt $ResultVM.count; $i++) {  
    [PSCustomObject]@{
    MC=$resultVM[$i].ProvisioningSchemeName
    VM=$resultVM[$i].VMName
    ImageAliged = $resultVM[$i].ImageOutOfDate
    LastBootTime = $resultVM[$i].LastBootTime
    AssignedImage = split-path -path $resultVM[$i].AssignedImage -leaf
    BootedImage = split-path -path $resultVM[$i].BootedImage -leaf
    }
  }
$reportVM |format-table -AutoSize

}


###--- verification ---###
Get-ProvTask -MaxRecordCount 999 |select Status, DateStarted,ProvisioningSchemeName, ProvisioningSchemeUid, TaskStateInformation |sort-object DateStarted
Get-ProvTask -MaxRecordCount 999 | where{$_.Status -eq “Running”} | select Status, DateStarted,ProvisioningSchemeName, ProvisioningSchemeU
Get-ProvTask -MaxRecordCount 999 | where{$_.Status -eq "Running"} | Stop-ProvTask
Get-ProvTask -MaxRecordCount 999 | where{$_.Type -eq “DisusedImageCleanup” -and $_.Status -ne “Finished”}
Get-ProvTask -MaxRecordCount 999 | where{$_.Type -eq “DisusedImageCleanup” -and $_.WorkflowStatus -eq “Terminated”} | Remove-ProvTask
Get-ProvSchemeMasterVMImageHistory  –AdminAddress $DDC –SortBy “Date”

###--- remove the error come from terminated task ---###
Get-ProvTask -MaxRecordCount 999 | where{$_.TaskStateInformation -eq “Terminated”}  | Remove-ProvTask


<### --- Health check v1  --- ###>

$ComputerName=""
$computerName |out-file serverlistDDC.txt

$parameters = @{
  ComputerName = Get-Content serverlistDDC.txt
  ScriptBlock = {Get-ProvScheme |where {$_.machinecount -gt 0} }
}

Invoke-Command @parameters |select IdentityPoolName, MasterImageVM | export-csv MCSimage.csv





