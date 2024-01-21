#$regioncode= "NonProd/EAS/EAS_EB/EAS_IF/SEA/JPE"
$regioncode= "NonProd"
$dateStr = Get-Date -Format "yyyyMMdd"
#$finalversion=20221203


<### --- this is the MC need updated list ---###>
$MCPreProd= Get-Content MC_PreProd_$regioncode.txt
$MCProd= Get-Content MC_Prod_$regioncode.txt
$ComputerName = Get-Content VM_Master_$regioncode.txt


if ($regioncode -like "EAS"){
$location="Eastasia"
$DDC= "AZAWVCTXHDCP1"
}elseif ($regioncode -eq "SEA"){
$location="Southeastasia"
$DDC="AZAWVCTXSDCP01"
}elseif ($regioncode -eq "JPE"){
$location="Japaneast"
$DDC="AZJWVCTXDCP02"
}elseif ($regioncode -eq "NonProd"){
$location="Eastasia"
$DDC="AZAWVCTXDCTD01"
}


### --- Step 1, extract the version used in Preprod --- ###

$version=@()
$MCPreProd| Foreach-object{
$MCConfig = Get-ProvScheme -AdminAddress $DDC –ProvisioningSchemeName $_
$dateStr=get-date($mcconfig.MasterImageVMDate) -Format "yyyyMMdd"
$version += "$dateStr"
}
$finalversion=$version | select -uniq 
$finalversion


### --- Step2, updating the PreProd MC in Studio  --- ###
Add-PSSnapin Citrix*

$MCProd| Foreach-object{
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


$MC| Foreach-object{
$MCConfig = Get-ProvScheme -AdminAddress $DDC –ProvisioningSchemeName $_ | where {$_.machinecount -gt 0} 
$MCImage = $MCConfig.MasterImageVM
$SnapshotFile = split-path -path $MCImage -leaf
$MasterServer = $snapshotfile.Substring(0,$snapshotfile.indexof("-"))
Write-Output  $DDC
Write-Output  $_
Write-Output  $MasterServer
Write-Output  $MCImage
Write-Output  '=== ### === ### === ### === ###'


