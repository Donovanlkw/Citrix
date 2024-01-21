### --- Perform Patching healthcheck 


### --- Graceful shutdown via Citrix Studio.

#$ComputerName="AZAWVCTXVDAD01"
#$ComputerName = Get-Content 'VM_Master_Non-Prod.txt'
#$ComputerName = Get-Content 'VM_Master_EAS.txt'
#$ComputerName = Get-Content 'VM_Master_JPE.txt'


$ComputerName = Get-Content 'VM_Master_SEA.txt'
$DDC="AZAWVCTXSDCP02"

$ComputerName| Foreach-object {
New-BrokerHostingPowerAction -AdminAddress $DDC -Action Shutdown -MachineName $_
}


### --- Taking Snapshot in Azure ---###


$resourceGroupName = 'mfc-rg-gis-ctx-sea'


#$resourceGroupName = 'mfc-rg-gis-ctx-eas'
#$resourceGroupName = 'mfc-rg-gis-ctx-jpe'
mfc-rg-gis-ctx-images-sea
$location = 'eastasia' 
Select-AzSubscription MFC-Asia-DevQA_Internal-S1 
$dateStr = Get-Date -Format "yyyyMMdd"

$ComputerName| Foreach-object {
$SnapshotName= $_+"-"+$dateStr
$vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $_
$snapshotconfig =  New-AzSnapshotConfig -SourceUri $vm.StorageProfile.OsDisk.ManagedDisk.Id -Location $location  -SkuName Standard_ZRS -CreateOption copy
$Snapshot = New-AzSnapshot -Snapshot $snapshotconfig -SnapshotName $snapshotName -ResourceGroupName $resourceGroupName 
}


