#$regioncode= "NonProd/EAS/EAS_EB/EAS_IF/SEA/JPE"
$regioncode= "NonProd"
$dateStr = Get-Date -Format "yyyyMMdd"
****

<### --- this is the MC need updated list ---###>
$MCPreProd= Get-Content MC_PreProd_$regioncode.txt
$MCProd= Get-Content MC_Prod_$regioncode.txt
$ComputerName = Get-Content VM_Master_$regioncode.txt

fill in 
if ($regioncode -like "EAS"){
$location="Eastasia"
$DDC="xxx"
}elseif ($regioncode -eq "SEA"){
$location="Southeastasia"
$DDC="xxx"
}elseif ($regioncode -eq "JPE"){
$location="Japaneast"
$DDC="xxx"
}elseif ($regioncode -eq "NonProd"){
$location="Eastasia"
$DDC="xxx"
}

###--- Step 1, power Off all master in Studio --- ###
$ComputerName| Foreach-object {
New-BrokerHostingPowerAction -AdminAddress $DDC -Action Shutdown -MachineName $_
}

###--- Step 2, taking snapshot in Azure --- ###
Select-AzSubscription MFC-Asia-Production-Internal-S4-Citrix
$resourceGroupName = "xxx"+$regioncode
$AzureVM| Foreach-object {
$SnapshotName= $_+"-"+$dateStr
$vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $_
$snapshotconfig =  New-AzSnapshotConfig -SourceUri $vm.StorageProfile.OsDisk.ManagedDisk.Id -Location $location  -SkuName Standard_ZRS -CreateOption copy
$Snapshot = New-AzSnapshot -Snapshot $snapshotconfig -SnapshotName $snapshotName -ResourceGroupName $resourceGroupName 
}


### --- Step3, updating the PreProd MC in Studio  --- ###
Add-PSSnapin Citrix*
$MCPreProd| Foreach-object{
$MCConfig = Get-ProvScheme -AdminAddress $DDC –ProvisioningSchemeName $_ | where {$_.machinecount -gt 0} 
$SnapshotfullPath = $MCConfig.MasterImageVM
$SnapshotFile = split-path -path $SnapshotfullPath -leaf
$MasterServer = $snapshotfile.Substring(0,$snapshotfile.indexof("-"))
$SnapshotPath = split-path -path $SnapshotfullPath
$NewSnapshotName = $MasterServer+"-"+$dateStr+".snapshot"
$NewSnapshotFullPath = $SnapshotPath+"\"+$NewSnapshotName
Write-Output  $_
#Write-Output  $MasterServer
#Write-Output  $SnapshotPath
#Write-Output  $NewsnapshotName
Write-Output  $SnapshotfullPath
Write-Output  $NewSnapshotFullPath
Write-Output  '=== ### === ### === ### === ###'

### --- update the MC  --- ###
#Set-ProvSchemeMetadata –AdminAddress $DDC -Name “ImageManagementPrep_DoImagePreparation” –ProvisioningSchemeName "$_"  -Value “True”
#Publish-ProvMasterVMImage -RunAsynchronously –AdminAddress $DDC –ProvisioningSchemeName "$_" –MasterImageVM "$NewSnapshotFullPath"

###--- assing adhoc-reboot tag to updated VM ---###
#$MCVM=Get-Brokermachine -AdminAddress $DDC -CatalogName $_
#$MCVm.Machinename | Foreach-object{
#add-brokertag -name 'adhoc-reboot' -machine $_
#}
}


###--- verification ---###
Get-ProvTask |select Status, DateStarted,ProvisioningSchemeName, ProvisioningSchemeUid |sort-object DateStarted
Get-ProvVM |select  VMName, BootedImage, LastBootTime  |Format-List


###--- Step 4, power ON all master --- ###
$ComputerName| Foreach-object {
New-BrokerHostingPowerAction -AdminAddress $DDC -Action TurnOn -MachineName $_
}


