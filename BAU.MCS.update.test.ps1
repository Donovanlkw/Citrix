https://support.citrix.com/article/CTX129205
https://www.citrix.com/blogs/2018/06/07/automate-the-cloud-citrix-azure-mcs-powershell/

#### Import Azure PowerShell Module
Import–Module -Name AzureRM
Connect to your Azure tenant


#### Connect to Azure Tenant
$Azurecred = get–credentials
Connect–AzureRmAccount -Credential $Azurecred

Create new Azure Virtual Machine
Now that we’re connected, we need to create the new Virtual Machine that is to become the new master image. We do this with the following script.


#### Disable Firewall on the machine
$StorageAccountName = “mySA”     ### Azure Storage Account name
$StorageSAKey = ‘mySAKey’        ### Azure Storage Account key, you can find this under keys at your storage account
$ResourceGroup = “myRG”          ### Resource group name
$VMName = “myVM”                 ### VM Name, example VDI-Master
$Location = ‘myLocation’         ### Azure RG location, example westeurope
$ContainerName = “script”
$temp = “C:\Temp”
$testtemp = Test-Path $temp
if (!$Testtemp)
    {
    New-Item -ItemType Directory -Path $temp | out-null
    }
New-Item -ItemType File -Path “$temp\disablefw.ps1” | out-null
$Filecontent = ‘Set-ItemProperty -Path “HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\DomainProfile” -name “EnableFirewall” -Value 0
Set-ItemProperty -Path “HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\PublicProfile” -name “EnableFirewall” -Value 0
Set-ItemProperty -Path “HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\Standardprofile” -name “EnableFirewall” -Value 0′
add-content “$temp\disablefw.ps1” $filecontent
$Localpath = “$temp\disablefw.ps1”
$context = New–AzureStorageContext –StorageAccountName $StorageAccountname –StorageAccountKey $StorageSAKey
Set–AzureRmCurrentStorageAccount –Context $Context
New–AzureStorageContainer -name $ContainerName
Set–AzureStorageBlobContent -File $LocalPath -container $ContainerName -Force
Set–AzureRmVMCustomScriptExtension -Name ‘myScript’ –ContainerName $ContainerName –FileName “disablefw.ps1” –StorageAccountName $StorageAccountName –ResourceGroupName $ResourceGroup –VMName $VMname –Run “disablefw.ps1” –Location $Location
Restart–AzureRmVM –ResourceGroupName $ResourceGroup -Name $VMName

Delete Azure Virtual Machine Public IP

The Azure virtual machine is created with a public IP address by default but we’re not going to use this. The following script will delete the public IP.


#### Delete Public IP Address
$ResourceGroup = “myRG”          ### Resource group name
$VMName = “myVM”                 ### VM Name, example VDI-Master
$nic = Get–AzureRmNetworkInterface -name $VMname –ResourceGroupName $ResourceGroup
$nic.IpConfigurations.publicipaddress.id = $null
Set–AzureRmNetworkInterface –NetworkInterface $nic
Remove–AzureRmPublicIpAddress –ResourceGroupName $ResourceGroup -Name $VMName -Force

Installation of Software and VDA

Now that we have a new Azure virtual machine, the private IP address, credentials, and the firewall is temporarily turned off. We can start deploying software and, of course, the Citrix VDA Software. You can do this with PowerShell or your own favorite automation product. You can also use my Ultimate Golden Image Automation Guide for software deployment tips and silent parameters. To install the VDA, you can check out this great article by Dennis Span or see the Citrix install command web page. And of course, don’t forget to optimize your image with the Citrix Optimizer and to seal your master image the right way with  BIS-F (Base Image Sealing Framework).

Stop Azure Virtual Machine

After deploying all the software and installing the VDA, it’s important to stop the Azure virtual machine before you update your machine catalog. You can do this with the following script.


#### Stop Azure VM
$ResourceGroup = “myRG”          ### Resource group name
$VMName = “myVM”                 ### VM Name, example VDI-Master
Stop–AzureRmVM –ResourceGroupName $ResourceGroup -name $VMName -Force

Update the Citrix Machine Catalog

Now that we have created a new master image, we need to update the Machine Catalog. If you run your own delivery controller in Azure or even on-premises, you can use the script below on any machine with Citrix Studio installed. If you use Citrix Cloud services you need to install the Citrix Cloud Remote PowerShell SDK. After installing the SDK, you can connect to your Citrix Cloud environment with the Get-XdAuthentication and then run the script.


#### Update MCS Machine Catalog
Add-PSSnapin Citrix*
$ResourceGroup = “myRG”          ### Resource group name
$VMName = “myVM”                 ### VM Name, example VDI-Master
$DDC = “myddc.company.com”       ### Delivery controller FQDN or the Citrix Cloud Connector FQDN if you use Citrix Cloud
$MCName = “myMC”                 ### Machine Catalog name
$AzureNetworkName = “myNetwork”  ### Network name under Azure Hosting Connection in Citrix Studio
$DDC = $DDC+“:80”
$VM = Get–AzureRmVM –ResourceGroupName $ResourceGroup -Name $VMName
$Diskname = $VM.StorageProfile.OsDisk.Name
$MasterImage = “XDHyp:\HostingUnits\$AzureNetworkName\image.folder\$ResourceGroup.resourcegroup\$Diskname.manageddisk”
Set–ProvSchemeMetadata  –AdminAddress $DDC -Name “ImageManagementPrep_DoImagePreparation” –ProvisioningSchemeName $MCname -Value“True”
$ProvScheme = Get–ProvScheme  –AdminAddress $DDC –ProvisioningSchemeName $MCName
$ProvSchemeGUID = $ProvScheme.ProvisioningSchemeUid
Publish–ProvMasterVMImage  –AdminAddress $DDC –MasterImageVM $MasterImage –ProvisioningSchemeName $MCName
Get–ProvSchemeMasterVMImageHistory  –AdminAddress $DDC –ProvisioningSchemeUid $ProvSchemeGUID –SortBy “Date”
Start–BrokerNaturalRebootCycle  –AdminAddress $DDC -InputObject @(“$MCName”)

Delete the VM

Now that the catalog is updated, there is no need to keep the Azure Virtual Machine and its resources; we can delete it with the following script:


#### Delete Azure VM and Resources
$ResourceGroup = “myRG”          ### Resource group name
$VMName = “myVM”                 ### VM Name, example VDI-Master
$Diskname = $VM.StorageProfile.OsDisk.Name
Remove–AzureRmVM –ResourceGroupName $ResourceGroup -Name $VMName -force
Remove–AzureRmDisk –ResourceGroupName $ResourceGroup -Name $Diskname -force
Remove–AzureRmNetworkInterface –ResourceGroupName $ResourceGroup -Name $VMname -Force
Remove–AzureRmNetworkSecurityGroup –ResourceGroupName $ResourceGroup -Name $VMname -Force

