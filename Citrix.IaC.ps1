### --- create a admin group --- ###
### --- Enable Read-only admin --- ###


$ADGroup= "MFCGD\"
$Role="Read Only Administrator"

New-AdminAdministrator -Name $ADGroup
Add-AdminRight -Role $role  -All -Administrator $ADGroup



### --- Enable Log , but not mandatry --- ###
$logdbconnection=Get-LogDBConnection
set-logsite -state Enabled



https://support.citrix.com/article/CTX208610/citrix-supportability-pack-updater


Import-Module "C:\Citrix_Supportability_Pack\Tools\Scout\Current\Utilities\Citrix.GroupPolicy.Commands.psm1"
Get-Module
Get-command -Module Citrix.GroupPolicy.Commands


###--- Disabled all the default policy ---###
set-ctxgrouppolicy -PolicyName "unfiltered" -type user -Enabled $false
set-ctxgrouppolicy -PolicyName "unfiltered" -type Computer -Enabled $false

set-ctxgrouppolicy -PolicyName "unfiltered" -type user -Enabled $false
set-ctxgrouppolicy -PolicyName "unfiltered" -type Computer -Enabled $false



asnp citrix*
$AdminAddress = "AZWAPNCTXSDDC01"
$MC ="MC-NI-EAS-GW-S-STG7"
$DG ="DG-NI-EAS-GW-S-STG7"
$VM =""
$Description = ""



###--- Create a MC --- ##
New-BrokerCatalog -AdminAddress $AdminAddress -Name $MC -SessionSupport MultiSession -AllocationType Random  -PersistUserChanges OnLocal -ProvisioningType Manual -Description $Description -MachinesArePhysical  $true
#change the parameter, "-MachinesArePhysical  $false."

###--- Add VM to MC --- ##
New-Brokermachine -MachineName $vm -CatalogUid (get-brokercatalog -name $MC).Uid

###--- Create a DG for Production --- ### 
New-BrokerDesktopGroup -AdminAddress $AdminAddress -Name $DG -DeliveryType DesktopsAndApps -SessionSupport MultiSession -desktop Shared -SecureIcaRequired $true -timezone "China Standard Time" -PublishedName $DG
$DesktopGroupUid=(Get-BrokerDesktopGroup -name $DG).Uid
$DesktopGroupUuid=(Get-BrokerDesktopGroup -name $DG).Uuid


###--- Assign VM to DG from MC --- ### 
Add-BrokerMachinesToDesktopGroup -DesktopGroup $DG -Catalog $MC -Count 1




###--- Publish Desktop to DG  --- ### 
New-BrokerEntitlementPolicyRule -Desktopgroupuid $DesktopGroupUid -Name $DG -PublishedName $DG -Description "Testing" -IncludedUserFilterEnabled $true -ExcludedUserFilterEnabled $true
Set-BrokerEntitlementPolicyRule -Name "$DG" -AddIncludedUsers ("mfcgd\AsiaCitrixAdmin","mfcgd\APP-AZ Asia Citrix-Admin" )


###--- Fixing the GUI Issue --- ### 
$FilternameAG= "$DG"+"_AG"
$FilternameDirect="$DG"+"_Directt"
New-BrokerAccessPolicyRule -Name $FilternameAG -Enabled $true -AllowedProtocols @("HDX","RDP") -AllowedUsers Filtered -AllowRestart $true -AllowedConnections ViaAG -IncludedSmartAccessFilterEnabled $true -IncludedUserFilterEnabled $true -DesktopGroupUid $DesktopGroupUid
New-BrokerAccessPolicyRule -Name $FilternameDirect -Enabled $true -AllowedProtocols @("HDX","RDP") -AllowedUsers Filtered -AllowRestart $true -AllowedConnections NotViaAG -IncludedSmartAccessFilterEnabled $true -IncludedUserFilterEnabled $true -DesktopGroupUid $DesktopGroupUid
New-BrokerAppEntitlementPolicyRule -Name $DG -Enabled $true -LeasingBehavior Allowed -SessionReconnection Always -IncludedUserFilterEnabled $false -DesktopGroupUid $DesktopGroupUid

#Set-BrokerAccessPolicyRule -Name 'DG-NI-EAS-GW-S-STG6_AG' -AddIncludedUsers ("mfcgd\leekwun")
#Set-BrokerAccessPolicyRule -Name 'DG-NI-EAS-GW-S-STG6_Directt' -AddIncludedUsers ("mfcgd\leekwun")






















New-AcctIdentityPool -IdentityPoolName 'TestCatalog' -NamingScheme 'Test###' -NamingSchemeType 'Numeric' -OU 'OU=MCS_machines,DC=A1,DC=ian,DC=local' -Domain 'A1.ian.local' -AllowUnicode -AdminAddress 'a1-ddc.a1.ian.local'</li>





Get-ConfigServiceGroup -ServiceType 'Broker' -MaxRecordCount 2147483647 -AdminAddress 'a1-ddc.a1.ian.local'</li>
  <li>Add-ConfigServiceGroupMetadata -ServiceGroupUid ef76fed3-d97b-4cb4-b649-e03b540995b2 -Property 'Citrix_DesktopStudio_BrokerCatalogIdentityPoolReferencePrefix_1' -Value 'be2e8725-4290-4283-9a49-223b89c6355a' -AdminAddress 'a1-ddc.a1.ian.local'</li>
  <li>New-ProvScheme -ProvisioningSchemeName 'TestCatalog_TestHost' -HostingUnitName 'TestHost' -IdentityPoolName 'TestCatalog' -VMCpuCount 1 -VMMemoryMB 2024 -CleanOnBoot -MasterImageVM 'XDHyp:\hostingunits\TestHost\A1-DDC.vm\initial install - not configured.snapshot' -RunAsynchronously -AdminAddress 'a1-ddc.a1.ian.local'</li>
  <li>Add-ProvTaskMetadata -TaskId 9a6e38f9-8cdf-4a5e-84cf-d8e239a92907 -Property 'Citrix_DesktopStudio_TaskGroupId' -Value '734f8e44-6ed8-4be2-b03e-3f330b48212a' -AdminAddress 'a1-ddc.a1.ian.local'</li>
  <li>Add-ProvTaskMetadata -TaskId 9a6e38f9-8cdf-4a5e-84cf-d8e239a92907 -Property 'Citrix_DesktopStudio_DesktopCatalogId' -Value '1' -AdminAddress 'a1-ddc.a1.ian.local'</li>
  <li>Add-ProvTaskMetadata -TaskId 9a6e38f9-8cdf-4a5e-84cf-d8e239a92907 -Property 'Citrix_DesktopStudio_ImagesToCopyCount' -Value '1' -AdminAddress 'a1-ddc.a1.ian.local'</li>
  <li>Add-ProvTaskMetadata -TaskId 9a6e38f9-8cdf-4a5e-84cf-d8e239a92907 -Property 'Citrix_DesktopStudio_VMsToCreateCount' -Value '1' -AdminAddress 'a1-ddc.a1.ian.local'</li>
  <li>Add-ProvTaskMetadata -TaskId 9a6e38f9-8cdf-4a5e-84cf-d8e239a92907 -Property 'Citrix_DesktopStudio_StartTime' -Value '634665492557161034' -AdminAddress 'a1-ddc.a1.ian.local'</li>
  <li>Get-ProvTask -TaskId 9a6e38f9-8cdf-4a5e-84cf-d8e239a92907 -MaxRecordCount 2147483647 -AdminAddress 'a1-ddc.a1.ian.local'</li>
  <li>Get-ProvTask -TaskId 9a6e38f9-8cdf-4a5e-84cf-d8e239a92907 -MaxRecordCount 2147483647 -AdminAddress 'a1-ddc.a1.ian.local'</li>
  <li>Set-BrokerCatalog -Name 'TestCatalog' -PvsForVM @('af68fd46-242f-4228-9e41-2034760ae5fc:ab3eac6f-230a-4067-8133-2e50d150f8df') -AdminAddress 'A1-DDC.A1.ian.local:80'</li>
  <li>Get-ChildItem -Path 'xdhyp:\connections' -AdminAddress 'a1-ddc.a1.ian.local'</li>
  <li>Get-BrokerHypervisorConnection -MaxRecordCount 2147483647 -AdminAddress 'A1-DDC.A1.ian.local:80'</li>
  <li>Get-AcctADAccount -IdentityPoolUid 00000000-0000-0000-0000-000000000000 -State 'Available' -Lock $False -MaxRecordCount 2147483647 -AdminAddress 'a1-ddc.a1.ian.local'</li>
  <li>New-AcctADAccount -IdentityPoolName 'TestCatalog' -Count 1 -AdminAddress 'a1-ddc.a1.ian.local'</li>
  <li>Add-ProvSchemeControllerAddress -ProvisioningSchemeName 'TestCatalog_TestHost' -ControllerAddress @('A1-DDC.A1.ian.local')</li>
  <li>New-ProvVM -ProvisioningSchemeName 'TestCatalog_TestHost' -ADAccountName @('A1\Test001$') -RunAsynchronously -AdminAddress 'A1-DDC.A1.ian.local:80'</li>
  <li>Add-ProvTaskMetadata -TaskId eb18debc-7d5c-4023-96e7-d4718137dbc2 -Property 'Citrix_DesktopStudio_TaskGroupId' -Value '734f8e44-6ed8-4be2-b03e-3f330b48212a' -AdminAddress 'a1-ddc.a1.ian.local'</li>
  <li>Add-ProvTaskMetadata -TaskId eb18debc-7d5c-4023-96e7-d4718137dbc2 -Property 'Citrix_DesktopStudio_DesktopCatalogId' -Value '1' -AdminAddress 'a1-ddc.a1.ian.local'</li>
  <li>Lock-ProvVM -ProvisioningSchemeName 'TestCatalog_TestHost' -VMID @('6d76e801-464d-5166-66e2-bc271a1544fe') -Tag 'Brokered' -AdminAddress 'a1-ddc.a1.ian.local'</li>
  <li>New-BrokerMachine -CatalogUid 1 -HostedMachineId '6d76e801-464d-5166-66e2-bc271a1544fe' -HypervisorConnectionUid 1 -MachineName 'S-1-5-21-2034153655-595690533-2570515849-1105' -AdminAddress 'A1-DDC.A1.ian.local:80'</li>
  <li>Add-ProvTaskMetadata -TaskId 9a6e38f9-8cdf-4a5e-84cf-d8e239a92907 -Property 'Citrix_DesktopStudio_TimeTaken' -Value '12427570003' -AdminAddress 'a1-ddc.a1.ian.local'</li>
  <li>Add-ProvTaskMetadata -TaskId eb18debc-7d5c-4023-96e7-d4718137dbc2 -Property 'Citrix_DesktopStudio_ImagesToCopyCount' -Value '1' -AdminAddress 'a1-ddc.a1.ian.local'</li>
  <li>Add-ProvTaskMetadata -TaskId eb18debc-7d5c-4023-96e7-d4718137dbc2 -Property 'Citrix_DesktopStudio_VMsToCreateCount' -Value '1' -AdminAddress 'a1-ddc.a1.ian.local'</li>
  <li>Add-ProvTaskMetadata -TaskId eb18debc-7d5c-4023-96e7-d4718137dbc2 -Property 'Citrix_DesktopStudio_StartTime' -Value '634665492557161034' -AdminAddress 'a1-ddc.a1.ian.local'</li>
  <li>Add-ProvTaskMetadata -TaskId eb18debc-7d5c-4023-96e7-d4718137dbc2 -Property 'Citrix_DesktopStudio_TimeTaken' -Value '12427570003' -AdminAddress 'a1-ddc.a1.ian.local'</li>




https://www.linkedin.com/pulse/create-citrix-cvad-policies-powershell-robin-meeuwsen

### --- crate policy --- ###
