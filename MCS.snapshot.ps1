### --- Perform Patching healthcheck

$ComputerName="AZAWVCTXVDAD01`

$ComputerName = Get-Content 'Non-Prod_Master.txt'
#$ComputerName = Get-Content 'SEA_Master.txt'
#$ComputerName = Get-Content 'EAS_Master.txt'
#$ComputerName = Get-Content 'JPE_Master.txt'
#$ComputerName = Get-Content 'EnI_Master.txt'

$resourceGroupName = 'mfc-rg-gis-ctx-eas'
$location = 'eastasia' 
Select-AzSubscription MFC-Asia-DevQA_Internal-S1 
$dateStr = Get-Date -Format "yyyyMMdd"

###--- Reboot and Shutdown the server ---###
$ComputerName| Foreach-object {
#Restart-AzVM -ResourceGroupName $resourceGroupName -Name $_.
Stop-AzVM -ResourceGroupName $resourceGroupName -Name $_ -
}

### --- Taking Snapshot in Azure ---###
$ComputerName| Foreach-object {
$SnapshotName= $_.+"-"+$dateStr+".snapshot"
$vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $MasterServer
$snapshotconfig =  New-AzSnapshotConfig -SourceUri $vm.StorageProfile.OsDisk.ManagedDisk.Id -Location $location -CreateOption copy
$Snapshot = New-AzSnapshot -Snapshot $snapshotconfig -SnapshotName $snapshotName -ResourceGroupName $resourceGroupName 
}
