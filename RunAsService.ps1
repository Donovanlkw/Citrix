#------ Reset security configuration ------#
Add-LocalGroupMember -Group "Administrators" -Member $user
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\" -Name "MinEncryptionLevel" 
set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\" -Name "DisableDomainCreds" -value "0"
set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -value "0"


#------ Reset security policy configuration ------#
secedit /export /cfg c:\temp\secpolori.inf
(gc c:\temp\secpolori.inf).replace("SeServiceLogonRight =", "SeServiceLogonRight = *S-1-5-80-0,") | Out-File c:\temp\secpolnew.inf
(gc c:\temp\secpolori.inf).replace("SeServiceLogonRight =", "SeServiceLogonRight = *S-1-5-80-1184457765-4068085190-3456807688-2200952327-3769537534,") | Out-File c:\temp\secpolfinal.inf
secedit /configure /db C:\Windows\security\local.sdb /areas USER_RIGHTS /cfg  c:\temp\secpolnew.inf


#------ Make Some Change ------#

#------ Restore security policy configuration ------#
secedit /configure /db C:\Windows\security\local.sdb /areas USER_RIGHTS /cfg  c:\temp\secpolfinal.inf
