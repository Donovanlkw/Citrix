### --- https://docs.citrix.com/en-us/federated-authentication-service/2212/config-manage/troubleshoot-logon.html
### --- 101, https://support.citrix.com/s/article/CTX340100-error-identity-assertion-logon-failed-unrecognized-federated-authentication-service?language=en_US
### --- 102, https://support.citrix.com/s/article/CTX564342-unable-to-start-desktop-with-fas-enabled-and-assert-upn-error-event-102-on-fas-server?language=en_US
### --- 107, https://support.citrix.com/s/article/CTX255423-error-event-id-107-citrixauthenticationidentityassertion-user-loses-access-to-mapped-network-drives-after-they-reconnect-to-disconnected-session?language=en_US

### --- https://support.citrix.com/s/article/CTX219849-fas-authentication-fails-with-an-error-the-username-or-password-is-incorrect?language=en_US
### --- https://support.citrix.com/s/article/CTX560789-citrix-fas-incorrect-username-and-password?language=en_US
### --- https://support.citrix.com/s/article/CTX217150-unable-to-login-using-the-fas-authentication-getting-stuck-on-please-wait-for-local-session-manager?language=en_US


$userid=""
$VDA=""
$ComputerName =  ""
$user=Get-aduser -Identity $userid
$userupn=$user.UserPrincipalName
$userupn

$StartTime=(Get-date).AddDays(-1)
$EndTime= ($StartTime).AddDays(1)
$StartTime
$EndTime

### --- All FAS related error/warning log.
$VDA_FASErr=Get-WinEvent -computername $VDA -FilterHashtable @{LogName='Application';ProviderName='Citrix.Authentication.IdentityAssertion';StartTime=$StartTime;EndTime=$EndTime} |where-object{$_.level -ne 4}|Select-Object -First 10
$VDA_FASErr


### --- collect all the FAS error/warning log.
$CTXHostSTF.fqdn | Foreach-object {
$STF_Err=Get-WinEvent -computername $_ -FilterHashtable @{LogName='Citrix Delivery Services';StartTime=$StartTime;EndTime=$EndTime}  |where-object{$_.level -ne 4}|Select-Object -First 10
### --- $STF_FASErr|where-object {$_.Message -like "*$userid*"} |Select-Object -First 10
$STF_Err
}

### ---  101 check the FAS policy --- ### 
$computername| Foreach-object {
Invoke-Command -Computer $_ -ScriptBlock {
Get-ItemProperty -Path "HKLM:SOFTWARE\Policies\Citrix\Authentication\UserCredentialService\Addresses"
Get-ItemProperty -Path "HKLM:SOFTWARE\WOW6432Node\Policies\Citrix\Authentication\UserCredentialService\Addresses"
Get-ItemProperty  -Path "HKLM:SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\" -name "fPromptForPassword"
(tnc opcs01028.corp.troweprice.net -port 80) |select  *
}
}

### --- Run in FAS to see if the certification valid --- ### 
$CitrixFasAddress = (Get-FasServerForUser -UserPrincipalNames $userupn).Server
$usercert=Get-FasUserCertificate -UserPrincipalName  $userupn
$usercert.certificate >usercert.crt
certutil -urlfetch -verify usercert.crt > certname.txt
$result= get-content  .\certname.txt
$result |select-string  "failure", "error" ,$userupn


### --- get the logon time. 
$VDA_FASLogin=Get-WinEvent -computername $ComputerName -FilterHashtable @{LogName='Application';StartTime=$StartTime;EndTime=$EndTime;id=106} |Select-Object -First 1
$VDA_FASLogin
$Authtime=($FASLogin).TimeCreated



### --- export all the FAS user certification --- ### 
$FASserver=Get-FasServer|select @{name='name'; expression={$_.Address}} 
$FASserver.name|Foreach-object {
$CitrixFasAddress= "$_"
$fasusercert=get-fasusercertificate -MaximumRecordCount 9999
$fasusercert|select UserPrincipalName, ExpiryDate, @{name='FASServer'; expression={$CitrixFasAddress}} |export-csv "fasUserCert.csv" -append 
}









### --- FAS AD authentication ID=9--- ###
$VDA_AuthErr=(Get-WinEvent -computername $VDA -FilterHashtable @{LogName='System';StartTime=$StartTime;EndTime=$EndTime; ID=9}).message
$VDA_AuthErr

### ---  101 check the FAS policy --- ### 
$VDA| Foreach-object {
Invoke-Command -Computer $_ -ScriptBlock {
Get-ItemProperty -Path "HKLM:SOFTWARE\Policies\Citrix\Authentication\UserCredentialService\Addresses"
Get-ItemProperty -Path "HKLM:SOFTWARE\WOW6432Node\Policies\Citrix\Authentication\UserCredentialService\Addresses"
#gci "C:\Windows\System32\config\systemprofile\AppData\LocalLow\Microsoft\CryptnetUrlCache\Content"
#(tnc opcs01028.corp.troweprice.net -port 80) |select  *
CERTUTIL -dump
}
}
















### --- collect all the FAS error/warning log.
$VDA_FASErr=Get-WinEvent -computername $ComputerName -FilterHashtable @{LogName='Application';ProviderName='Citrix.Authentication.IdentityAssertion';StartTime=$StartTime;EndTime=$EndTime} |where-object{$_.level -ne 4}|Select-Object -First 10
$VDA_FASErr
$VDA_FASLogin=Get-WinEvent -computername $ComputerName -FilterHashtable @{LogName='Application';StartTime=$StartTime;EndTime=$EndTime;id=106} |Select-Object -First 1
$VDA_FASLogin
$Authtime=($FASLogin).TimeCreated


### --- collect all the FAS error/warning log.
$STF=""
$STF_FASErr=Get-WinEvent -computername $STF -FilterHashtable @{LogName='Citrix Delivery Services';StartTime=$StartTime;EndTime=$EndTime} 
$STF_FASErr|where-object {$_.Message -like "*$userid*"} |Select-Object -First 10
$STF_FASErr



### --- https://docs.citrix.com/en-us/federated-authentication-service/2212/config-manage/troubleshoot-logon.html
### --- 101, https://support.citrix.com/s/article/CTX340100-error-identity-assertion-logon-failed-unrecognized-federated-authentication-service?language=en_US
### --- 102, https://support.citrix.com/s/article/CTX564342-unable-to-start-desktop-with-fas-enabled-and-assert-upn-error-event-102-on-fas-server?language=en_US
### --- 107, https://support.citrix.com/s/article/CTX255423-error-event-id-107-citrixauthenticationidentityassertion-user-loses-access-to-mapped-network-drives-after-they-reconnect-to-disconnected-session?language=en_US
### ---  check VDA list and STF 

$computername| Foreach-object {
Invoke-Command -Computer $_ -ScriptBlock {
Get-ItemProperty -Path "HKLM:SOFTWARE\Policies\Citrix\Authentication\UserCredentialService\Addresses"
}
}





### --- this is how the FAS involed. 
1. user sign-in the STF, FAS get the certification. 

Add-PSSnapin Citrix.Authentication.FederatedAuthenticationService.V1

