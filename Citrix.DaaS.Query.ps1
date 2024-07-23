### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- 
### --- Searching assigned published App  & Shared Desktop (not dedicated)--- ### 
$PublishApp=$user.memberof|foreach{
Get-BrokerResource -User $user.SamAccountName -Groups $_}
$PublishApp | select name -Unique



### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- 

#Get the ACL for Destkop
Get-BrokerAccessPolicyRule -MaxRecordCount 10000 |select-Object  DesktopGroupName, IncludedUserFilterEnabled  -ExpandProperty IncludedUsers | Format-table DesktopGroupName, IncludedUserFilterEnabled, FullName |out-file DG.csv

#Get the ACL for PusblishDesktop in XenApp
Get-BrokerEntitlementPolicyRule -MaxRecordCount 10000 |select-Object PublishedName, Enabled -ExpandProperty IncludedUsers | Format-table  PublishedName, Enabled, FullName |out-file Desktop.csv

#Get the ACL for ApplicationGroup access
Get-BrokerApplicationGroup -MaxRecordCount 10000 | Select-Object name, UserFilterEnabled, @{l="AssociatedUserNames";e={$_.AssociatedUserNames -join ","}}  |export-csv AG.csv

#Get the ACL for Application access
Get-BrokerApplication -MaxRecordCount 10000 | Select-Object name, UserFilterEnabled, @{l="AssociatedUserNames";e={$_.AssociatedUserNames -join ","}} |export-csv A.csv



### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- 
### --- CTX Search Servers application published from Server --- ###  
$publishAppName = "Chrome"
$Selectedapp=$PublishApp|where {$_.name -match  $publishAppName} | select name, AssociatedDesktopGroupuUids |select -Unique

$computername =Get-BrokerMachine -DesktopGroupUuid $Selectedapp[1].AssociatedDesktopGroupuUids 
$computername =Get-BrokerMachine -DesktopGroupUid 

$computername.dnsname|foreach{
(Get-ADComputer -Identity $_ -Properties *).CanonicalName 
}

### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- 
### --- CTX seach tags in XA/XD VM--- ###
$tags="tagsname"
$XD |select dnsname, desktopgroupname, @{name='tags'; Expression={$_.tags}} |select-string -AllMatches  $tags



####################################################################
### Get the enabled application in enabled DG ###

Get-BrokerDesktopGroup -filter {InMaintenanceMode -eq "False"}  | ForEach-Object {
Get-BrokerApplication -AllAssociatedDesktopGroupUUID $_.UUID.guid -filter {Enabled -eq "True"}  
     } |     Select-Object name, UserFilterEnabled, @{l="AssociatedUserNames";e={$_.AssociatedUserNames -join ","}} |export-csv "$env:computername.csv"

$ComputerName="localhost"

#`r`

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


####################################################################

#Get the VM Inventory from Citrix Studio

$computer = "DDC"
Invoke-Command -Computer $computer -ScriptBlock {
	Get-BrokerDesktop   -MaxRecordCount 10000 
 } |	Select-Object MachineName, @{l="AssociatedUserNames";e={$_.AssociatedUserNames -join ","}} |Export-Csv $computer
 
# Merge all the files
Get-ChildItem -include azaw* -Recurse |get-content|Out-File StudioInventory -NoClobber



### --- get the reboot from MCS servers --- ### 

$parameters = @{
  ComputerName = Get-Content VM_DDC.txt
  ScriptBlock = {Get-Brokermachine -ProvisioningType MCS}
}

Invoke-Command @parameters |select DNSName |export-csv output_VM_MCS.txt

$ComputerNameMCS = Import-csv output_VM_MCS.txt -Header MCSserver
Get-CimInstance -ComputerName $ComputerNameMCS.MCSserver -Class win32_operatingsystem | select csname, lastbootuptime |Sort-Object lastbootuptime|out-file output_bootuptime.txt


### --- last reboot time / Regirstion --- ###
 $x = get-brokerdesktop -ostype *201*
 $x |select LastDeregistrationReason, LastDeregistrationTime, MachineName, ostype


### --- get the reboot from MCS servers --- ### 

