$GPOName =

[xml]$xmlRef=Get-content $GPOName".xml" 
[xml]$xmlDiff=Get-content $GPOName".xml" 

#[xml]$xmlRef=Get-GPOreport -name "$GPOName" -ReportType XML
#[xml]$xmlDiff=Get-GPOreport -name "$GPOName" -ReportType XML


Compare-Object -ReferenceObject $xmla.DocumentElement.ChildNodes.ExtensionData.extension.type -DifferenceObject $xmlb.DocumentElement.ChildNodes.ExtensionData.extension.type -IncludeEqual



### --- namespace defintion for GPO
$NameSpace = @{
GPO='http://www.microsoft.com/GroupPolicy/Settings'
Internet='http://www.microsoft.com/GroupPolicy/Settings/ControlPanel/Internet'
Scripts='http://www.microsoft.com/GroupPolicy/Settings/Scripts'
Printers='http://www.microsoft.com/GroupPolicy/Settings/Printers'
Files='http://www.microsoft.com/GroupPolicy/Settings/Files'
Policy='http://www.microsoft.com/GroupPolicy/Settings/Registry'
FolderRedirection="http://www.microsoft.com/GroupPolicy/Settings/FolderRedirection"

#GroupPolicy Perference
EnvironmentVariables='http://www.microsoft.com/GroupPolicy/Settings/Environment'
RegistrySettings='http://www.microsoft.com/GroupPolicy/Settings/Windows/Registry'
Services='http://www.microsoft.com/GroupPolicy/Settings/Services'
Folder='http://www.microsoft.com/GroupPolicy/Settings/Folders'
DriveMaps='http://www.microsoft.com/GroupPolicy/Settings/DriveMaps'

Lugs='http://www.microsoft.com/GroupPolicy/Settings/Lugs'
PrinterConnections='http://www.microsoft.com/GroupPolicy/Settings/PrinterConnections'	
ScheduledTasks='http://www.microsoft.com/GroupPolicy/Settings/ScheduledTasks'
Dot3Svc='http://www.microsoft.com/GroupPolicy/Settings/Dot3Svc'
PowerOptions='http://www.microsoft.com/GroupPolicy/Settings/PowerOptions'
Auditing='http://www.microsoft.com/GroupPolicy/Settings/Auditing'
PublicKey='http://www.microsoft.com/GroupPolicy/Settings/PublicKey'	
WindowsFirewall='http://www.microsoft.com/GroupPolicy/Settings/WindowsFirewall'
nrpt='http://www.microsoft.com/GroupPolicy/Settings/nrpt'
Security='http://www.microsoft.com/GroupPolicy/Settings/Security'
SoftwareInstallation="http://www.microsoft.com/GroupPolicy/Settings/SoftwareInstallation"

#IE='http://www.microsoft.com/GroupPolicy/Settings/IE'
}

$xmlR1=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//EnvironmentVariables:EnvironmentVariables").node 
$xmlR2=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//Lugs:User").node
$xmlR3=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//Lugs:Group").node
$xmlR4=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//Security:Account").node
$xmlR5=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//Security:UserRightsAssignment").node
$xmlR6=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//Security:SecurityOptions").node
$xmlR7=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//Services:NTServices").node
$xmlR8=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//Scripts:Scripts").node
$xmlR9=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//FolderRedirection:Folder").node
$xmlR10=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//DriveMaps:DriveMapSettings ").node
$xmlR11=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//Folder:Folders").node 
$xmlR12=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//ScheduledTasks:ScheduledTasks").node
$xmlR13=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//Dot3Svc:Dot3SvcSetting").node
$xmlR14=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//PowerOptions:PowerOptions").node
$xmlR15=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//Auditing:AuditSetting").node
$xmlR16=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//PublicKey:EFSSettings").node
$xmlR17=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//WindowsFirewall:GlobalSettings").node
$xmlR18=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//WindowsFirewall:DomainProfile").node
$xmlR19=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//WindowsFirewall:PublicProfile").node
$xmlR20=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//WindowsFirewall:PrivateProfile").node
$xmlR21=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//nrpt:Global").node
$xmlR22=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//RegistrySettings:Registry").node
$xmlR23=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//Policy:Policy").node
$xmlR24=(select-xml -xml $xmlRef -namespace $NameSpace -xpath "//Policy:RegistrySetting").node

### --- ### --- ### --- ### --- ### --- ### --- ### --- 


$xmlD1=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//EnvironmentVariables:EnvironmentVariables").node 
$xmlD2=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//Lugs:User").node
$xmlD3=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//Lugs:Group").node
$xmlD4=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//Security:Account").node
$xmlD5=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//Security:UserRightsAssignment").node
$xmlD6=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//Security:SecurityOptions").node
$xmlD7=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//Services:NTServices").node
$xmlD8=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//Scripts:Scripts").node
$xmlD9=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//FolderRedirection:Folder").node
$xmlD10=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//DriveMaps:DriveMapSettings ").node
$xmlD11=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//Folder:Folders").node 
$xmlD12=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//ScheduledTasks:ScheduledTasks").node
$xmlD13=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//Dot3Svc:Dot3SvcSetting").node
$xmlD14=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//PowerOptions:PowerOptions").node
$xmlD15=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//Auditing:AuditSetting").node
$xmlD16=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//PublicKey:EFSSettings").node
$xmlD17=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//WindowsFirewall:GlobalSettings").node
$xmlD18=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//WindowsFirewall:DomainProfile").node
$xmlD19=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//WindowsFirewall:PublicProfile").node
$xmlD20=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//WindowsFirewall:PrivateProfile").node
$xmlD21=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//nrpt:Global").node
$xmlD22=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//RegistrySettings:Registry").node
$xmlD23=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//Policy:Policy").node
$xmlD24=(select-xml -xml $xmlDiff -namespace $NameSpace -xpath "//Policy:RegistrySetting").node


### --- start compare two GPO ### --- 
$CompareResult=for($i=1; $i -le 30; $i++)
{$i
$cmd=-join('Compare-Object -ReferenceObject $xmlR', "$i",'.innerxml -DifferenceObject $xmlD',"$i", ".innerxml")
Invoke-Expression $cmd
}

