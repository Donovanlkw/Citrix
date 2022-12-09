<### --- Healthcheck v2  --- ###>

$DDC |ForEach{
$result=Get-ProvScheme -AdminAddress $_ |where {$_.machinecount -gt 0} 
$Snapshot=split-path -path $result.MasterImageVM -leaf
$MC=$result.IdentityPoolName

  $report =@()
  $report= for($i= 0; $i -lt $Result.count; $i++) {  
    [PSCustomObject]@{
    MC= $result[$i].IdentityPoolName
    ImageUpdate = $result[$i].MasterImageVMDate
    Snapshot= split-path -path $result[$i].MasterImageVM -leaf
    }
  }
$report |Format-Table
}


<### --- verificaiton  --- ###>

 Get-ProvTask -MaxRecordCount 9999 | where{$_.Status -eq "Running"} | Stop-ProvTask
 
###--- verification ---###
Get-ProvTask |select Status, DateStarted,ProvisioningSchemeName, ProvisioningSchemeUid |sort-object DateStarted
Get-ProvVM |select  VMName, BootedImage, LastBootTime  |Format-List


### --- Validation --- ###
Get-ProvTask -MaxRecordCount 999 |select Status, DateStarted,ProvisioningSchemeName, ProvisioningSchemeUid |sort-object DateStarted
Get-ProvTask -MaxRecordCount 999 | where {$_.Status -eq “Running”}  |select Status, DateStarted,ProvisioningSchemeName, ProvisioningSchemeUid
Get-ProvVM |select  VMName, BootedImage, LastBootTime  |Format-List




### --- Validation --- ###
Get-ProvTask |select Status, DateStarted,ProvisioningSchemeName, ProvisioningSchemeUid
Get-ProvTask | where {$_.Status -eq “Running”}
Get-ProvVM |select  VMName, BootedImage |Format-List


Get-ProvTask | where {$_.Type -eq “DisusedImageCleanup” -and $_.Status -ne “Finished”}
Get-ProvTask | where {$_.Type -eq “DisusedImageCleanup” -and $_.WorkflowStatus -eq “Terminated”} | Remove-ProvTask
Get-ProvSchemeMasterVMImageHistory  –AdminAddress $DDC –ProvisioningSchemeUid $ProvSchemeGUID –SortBy “Date”

 
 

<### --- Health check v1  --- ###>

$ComputerName=""
$computerName |out-file serverlistDDC.txt

$parameters = @{
  ComputerName = Get-Content serverlistDDC.txt
  ScriptBlock = {Get-ProvScheme |where {$_.machinecount -gt 0} }
}

Invoke-Command @parameters |select IdentityPoolName, MasterImageVM | export-csv MCSimage.csv





