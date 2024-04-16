##################################################
# Login VSI Active Directory setup script
# v1.1
##################################################
$baseOU = "DC=LAB,DC=localdomain"
$numUsers = "10"
$userName = "LoginVSI"
$passWord = "Password1"
$userDomain = "LAB.localdomain"
$VSIshare = "\\RDS2\LoginVSI"
$FormatLength = "1"
$LauncherAccount = "Launcher-v4"
$LauncherPassword = "Password!"
$ConfirmPreference="none"
function Get-ScriptDirectory
{
Split-Path $script:MyInvocation.MyCommand.Path
}
Import-Module ActiveDirectory
Import-Module GroupPolicy
New-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false -name "LoginVSI" -path "$baseOU"
New-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false -name "Computers" -path "OU=LoginVSI,$baseOU"
New-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false -name "Launcher" -path "OU=Computers,OU=LoginVSI,$baseOU"
New-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false -name "Target" -path "OU=Computers,OU=LoginVSI,$baseOU"
New-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false -name "Users" -path "OU=LoginVSI,$baseOU"
New-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false -name "Launcher" -path "OU=Users,OU=LoginVSI,$baseOU"
New-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false -name "Target" -path "OU=Users,OU=LoginVSI,$baseOU"
New-ADGroup -path "OU=LoginVSI,$baseOU" -name "LoginVSI" -GroupScope "Global" -GroupCategory "Security"
for ($i=1; $i -le $numUsers; $i++)
{$fn = "{0:D$FormatLength}" -f $i
$finalUser = $userName + $fn
New-ADUser -name "$finalUser" -SamAccountName "$finalUser" -UserPrincipalName "$finalUser@$userDomain" -GivenName "$finalUser" -Surname "$finalUser" -DisplayName "$finalUser" -path "OU=Target,OU=Users,OU=LoginVSI,$baseOU" -AccountPassword (ConvertTo-SecureString -AsPlainText "$passWord" -Force) -ChangePasswordAtLogon $false -PasswordNeverExpires $true -ScriptPath "V4-VSI_Logon.cmd" -HomePage "http://www.loginvsi.com" -Enabled $true
Add-ADGroupMember -Identity "CN=LoginVSI,OU=LoginVSI,$baseOU" -Members $finalUser}
Try {
New-ADUser -name "Launcher-V4" -SamAccountName "$LauncherAccount" -UserPrincipalName "$LauncherAccount@$userDomain" -GivenName "VSI Launcher V4" -Surname "VSI Launcher V4" -DisplayName "VSI Launcher V4" -path "OU=Launcher,OU=Users,OU=LoginVSI,$baseOU" -AccountPassword (ConvertTo-SecureString -AsPlainText "$LauncherPassword" -Force) -ChangePasswordAtLogon $false -PasswordNeverExpires $true -HomePage "http://www.loginvsi.com" -Enabled $true -ScriptPath "V4-VSI_Launcher.cmd"
}
catch{}
Add-ADGroupMember -Identity "CN=LoginVSI,OU=LoginVSI,$baseOU" -Members (Get-ADUser -Filter 'Name -like "Launcher-V4"' -SearchBase "OU=Launcher,OU=Users,OU=LoginVSI,$baseOU") 
import-gpo -BackupGpoName "Login VSI 4.1.x (Launcher)" -TargetName "Login VSI Launcher-V416" -path "$VSIshare\_VSI_Binaries\AD Setup\Launcher" -CreateIfNeeded | new-gplink -target "OU=Launcher,OU=Computers,OU=LoginVSI,$baseOU"
import-gpo -BackupGpoName "Login VSI 4.1.x (User&Comp)" -TargetName "Login VSI Target-V416" -path "$VSIshare\_VSI_Binaries\AD Setup\Target" -CreateIfNeeded | new-gplink -target "OU=Target,OU=Computers,OU=LoginVSI,$baseOU"
Get-GPO -name "Login VSI Target-V416" | new-gplink -target "OU=Target,OU=Users,OU=LoginVSI,$baseOU"
Set-Content "\\$userDomain\SYSVOL\$userDomain\scripts\V4-VSI_Logon.cmd" "CALL `"$VSIshare\_VSI_Binaries\Target\Logon.cmd`""
Set-Content "\\$userDomain\SYSVOL\$userDomain\scripts\V4-VSI_Launcher.cmd" "CALL `"$VSIshare\_VSI_Binaries\Launcher\Agent.exe`""
Write-Host "Do not forget to move the target machines to the correct Login VSI computers OU"
Write-Host "Press any key to continue ..."
$Pressanykey = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
