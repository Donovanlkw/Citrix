#----- Declare variables -----# 

$DomainName= "lab.local" 
$DomaninNetBIOSName= "LAB" 
$DomainDN="DC=LAB,DC=local" 
$DomainAdmin = "msroot" 
$Password =  "Password1" 
$Encryptedpassword=$Password | ConvertTo-SecureString -Force -AsPlainText 


$DatabasePath = "c:\windows\NTDS" 
$DomainMode = "WinThreshold" 
$ForestMode = "WinThreshold" 
$LogPath = "c:\windows\NTDS" 
$SysVolPath = "c:\windows\SYSVOL" 
$featureLogPath = "c:\poshlog\featurelog.txt"  
$Password = "Pass1w0rd" 
$SecureString = ConvertTo-SecureString $Password -AsPlainText -Force 
#$Password = Read-Host -Prompt  'Enter SafeMode Admin Password' -AsSecureString 
  

#----- Install AD DS, DNS and GPMC ------# 
start-job -Name addFeature -ScriptBlock {  
Add-WindowsFeature RSAT-AD-Tools 
Add-WindowsFeature -Name "ad-domain-services" -IncludeAllSubFeature -IncludeManagementTools  
Add-WindowsFeature -Name "dns" -IncludeAllSubFeature -IncludeManagementTools  
Add-WindowsFeature -Name "gpmc" -IncludeAllSubFeature -IncludeManagementTools }  
Wait-Job -Name addFeature  
Get-WindowsFeature | Where installed >>$featureLogPath 


#----- Create New AD Forest ------# 
Import-Module ADDSDeployment 
#Create New AD Forest 
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath $DatabasePath -DomainMode $DomainMode -DomainName $DomainName -SafeModeAdministratorPassword $SecureString -DomainNetbiosName $DomainNetBIOSName -ForestMode $ForestMode -InstallDns:$true -LogPath $LogPath -NoRebootOnCompletion:$false -SysvolPath $SysVolPath -Force:$true 


#----- $setup other Service -----# 
Install-windowsfeature AD-Certificate -IncludeAllSubFeature 
Install-windowsfeature ADFS-Federation -IncludeAllSubFeature 
Install-windowsfeature DHCP -IncludeAllSubFeature 
Install-WindowsFeature print-services -IncludeAllSubFeature 

#---- New Standard OU -----# 
$ou=Get-ADDomain 
$ou.DistinguishedName 
New-ADOrganizationalUnit -name "ServiceAccount" -path $ou 
New-ADOrganizationalUnit -name "Windows 10" -path $ou 
New-ADOrganizationalUnit -name "Production" -path  "OU=Windows 10, $ou" 
New-ADOrganizationalUnit -name "Pilot" -path  "OU=Windows 10, $ou" 
New-ADOrganizationalUnit -name "Test" -path  "OU=Windows 10, $ou" 
New-ADOrganizationalUnit -name "O365" -path $ou 


New-GPO O365 
New-GPO CIS1803_L1 
New-GPO CIS1803_L2 
New-GPO Folder_Redirection 
New-GPO Wind10_Customization  

#---- Add Domian Admin users -----# 
New-ADUser -Name $DomainAdmin -GivenName $DomainAdmin  -Surname "" -SamAccountName $DomainAdmin -Path "CN=Users,$DomainDN" -AccountPassword($Encryptedpassword) -Enabled $true 
Add-ADGroupMember -Identity "Domain Admins" -Members $DomainAdmin  
Add-ADGroupMember -Identity "schema Admins" -Members $DomainAdmin
