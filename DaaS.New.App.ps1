$Name= "NI-EAS-GA-S-STG"
$DG="DG-"+ $Name
$MC="MC-"+ $Name
$AG="AG-"+ $Name
$AGuser = "Domain\ACL"
$Description = "General VDA"

### --- New Application Group ---###
New-BrokerApplicationGroup -name $AG -Description $Description
Add-BrokerApplicationGroup $AG -DesktopGroup $DG
Set-BrokerApplicationGroup $AG -UserFilterEnabled $true
Add-BrokerUser $AGuser -ApplicationGroup $AG

### --- New System  Application  ---###
$app="notepad","mstsc","explorer","cmd"
$app|foreach{
$commandline ="%SystemRoot%\"+$_+".exe"
$workingdirectory="%SystemDrive%\Windows"
New-BrokerApplication -ApplicationType HostedOnDesktop -Name $_ -CommandLineExecutable $commandline -ApplicationGroup $AG  -WorkingDirectory $workingdirectory
}

### --- New Office  Application  ---###
$app="WINWORD","EXCEL","POWERPNT","MSACCESS"

C:\Program Files (x86)\Microsoft Office\Office16\.EXE
$app|foreach{
$commandline ="C:\Program Files (x86)\Microsoft Office\Office16\"+$_+".exe"
$workingdirectory="C:\Program Files (x86)\Microsoft Office\Office16"
New-BrokerApplication -ApplicationType HostedOnDesktop -Name $_ -CommandLineExecutable $commandline -ApplicationGroup $AG  -WorkingDirectory $workingdirectory
}



### --- New   Application  ---###
$app="notepad","mstsc","explorer","cmd"
$app|foreach{
$commandline ="%SystemRoot%\"+$_+".exe"
$workingdirectory="%SystemDrive%\Windows"
New-BrokerApplication -ApplicationType HostedOnDesktop -Name $_ -CommandLineExecutable $commandline -ApplicationGroup $AG  -WorkingDirectory $workingdirectory
}







New-ProvScheme
-CleanOnBoot
-CustomProperties "<CustomProperties xmlns=`"http://schemas.citrix.com/2014/xd/machinecreation`" xmlns:xsi=`"http://www.w3.org/2001/XMLSchema-instance`"><Property xsi:type=`"StringProperty`" Name=`"UseManagedDisks`" Value=`"true`" /><Property xsi:type=`"StringProperty`" Name=`"StorageAccountType`" Value=`"Premium_LRS`" /><Property xsi:type=`"StringProperty`" Name=`"ResourceGroups`" Value=`"benvaldev5RG3`" /><Property xsi:type=`"StringProperty`" Name=`"PersistWBC`" Value=`"true`" /></CustomProperties>"
-HostingUnitName "adSubnetScale1"
-IdentityPoolName "BV-WBC1-CAT1"
-MasterImageVM "XDHyp:\HostingUnits\adSubnetScale1\image.folder\GoldImages.resourcegroup\W10MCSIO-01_OsDisk_1_a940e6f5bab349019d57ccef65d2c7e3.manageddisk"
-NetworkMapping @{"0"="XDHyp:\HostingUnits\adSubnetScale1\\virtualprivatecloud.folder\CloudScale02.resourcegroup\adVNET.virtualprivatecloud\adSubnetScale1.network"}
-ProvisioningSchemeName "BV-WBC1-CAT1"
-ServiceOffering "XDHyp:\HostingUnits\adSubnetScale1\serviceoffering.folder\Standard_D2s_v3.serviceoffering"
-UseWriteBackCache
-WriteBackCacheDiskSize 127
-WriteBackCacheMemorySize 256




# How to add a machine to delivery group using PowerShell

Add-BrokerMachine "MyDomain\MyMachine" -DesktopGroup "MyDesktopGroup"

### https://www.citrix.com/blogs/2012/03/06/using-powershell-to-create-a-catalog-of-machine-creations-services-machines/
