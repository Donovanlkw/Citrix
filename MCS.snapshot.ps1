### --- Perform Patching healthcheck 


### --- Graceful shutdown via Citrix Studio.


$ComputerName="AZAWVCTXVDAD01"

$ComputerName = Get-Content 'Non-Prod_Master.txt'
#$ComputerName = Get-Content 'SEA_Master.txt'
#$ComputerName = Get-Content 'EAS_Master.txt'
#$ComputerName = Get-Content 'JPE_Master.txt'
#$ComputerName = Get-Content 'EnI_Master.txt'
$ComputerName| Foreach-object {
New-BrokerHostingPowerAction -Action Shutdown -MachineName $_
}




### --- Taking Snapshot in Azure ---###
$resourceGroupName = 'mfc-rg-gis-ctx-eas'
$location = 'eastasia' 
Select-AzSubscription MFC-Asia-DevQA_Internal-S1 
$dateStr = Get-Date -Format "yyyyMMdd"

$ComputerName| Foreach-object {
$SnapshotName= $_+"-"+$dateStr+".snapshot"
$vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $_
$snapshotconfig =  New-AzSnapshotConfig -SourceUri $vm.StorageProfile.OsDisk.ManagedDisk.Id -Location $location  -SkuName Standard_ZRS -CreateOption copy
$Snapshot = New-AzSnapshot -Snapshot $snapshotconfig -SnapshotName $snapshotName -ResourceGroupName $resourceGroupName 
}


