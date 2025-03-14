#https://support.citrix.com/article/CTX461323/while-using-fas-application-launch-fails-with-error-cannot-start-app-

### ---  FQDN/IP for Citrix StoreFront --- ###
$CTXHostSTF=@()
$FQDN=
$IP=

$CTXHostSTF= for($i= 0; $i -lt $FQDN.count; $i++) {  
    [PSCustomObject]@{
    FQDN= $FQDN[$i]
    IP= $IP[$i]
    }
}



### ---  FQDN/IP for Citrix FAS server --- ###
$CTXHostFAS=@()
$FQDN= 

$IP= 

$CTXHostFAS= for($i= 0; $i -lt $FQDN.count; $i++) {  
    [PSCustomObject]@{
    FQDN= $FQDN[$i]
    IP= $IP[$i]
    }
}





#----- Collect all log from server group in last 1 days-----# 
$ComputerName= $CtxhostSTF.fqdn
$StartTime=(Get-date).AddDays(-1)
$EndTime= Get-date
$LogName="Citrix Delivery Services"
$eventid="1"
$level="2"
$ProviderName="Citrix Store Service"
$STFlog=$ComputerName|Foreach {
Get-WinEvent -ComputerName $_ -FilterHashTable @{LogName=$LogName;Id=$eventid;ProviderName=$ProviderName;level=$level;StartTime=$StartTime;EndTime=$EndTime}
}

#----- Collect all log from server group in last 1 days-----# 
$ComputerName= $CtxhostFAS.fqdn
$StartTime=(Get-date).AddDays(-1)
$EndTime= Get-date
$LogName="Application"
$eventid="102"
$level="2"
$ProviderName="Citrix.Authentication.FederatedAuthenticationService"
$FASlog=$ComputerName|Foreach {
Get-WinEvent -ComputerName $_ -FilterHashTable @{LogName=$LogName;Id=$eventid;ProviderName=$ProviderName;level=$level;StartTime=$StartTime;EndTime=$EndTime}
}
### show the locked out message only.
$FASlog.Message | out-string -stream|select-string "locked out"
$errLog= $FASlog.Message

if ($FASlog.Message.count -gt 0){
    $tmpUPN=$errLog  |Foreach {
    $findcharStart = $_.IndexOf("UPN [")
    $tmpupn=$_.Substring($findcharstart+5)
    $findcharEnd = $tmpupn.IndexOf(".com] ")
    $upn=$tmpupn.Substring(0,$findcharEnd+4)
    $upn
    }
    $allUPN = $tmpUPN|sort -unique
    
    ### ---  A.D. User UPN and date related items--- ###
    $allUPN  |Foreach {
    $user=Get-ADUser -Filter{UserPrincipalName -eq $_} -Properties *
    write-host $_
    $user |select UserPrincipalName,lockedout, Whenchanged
    }
}





Write-host "total error in SF" $STFlog.Message.count
Write-host "total error in FAS" $FASlog.Message.count













### --- this is how the FAS involed. 
1. user sign-in the STF, FAS get the certification. 

Add-PSSnapin Citrix.Authentication.FederatedAuthenticationService.V1





### --- identify a kerberor id 9 error --- ###
### --- https://support.citrix.com/s/article/CTX219849-fas-authentication-fails-with-an-error-the-username-or-password-is-incorrect?language=en_US
### --- https://support.citrix.com/s/article/CTX560789-citrix-fas-incorrect-username-and-password?language=en_US
### --- https://support.citrix.com/s/article/CTX217150-unable-to-login-using-the-fas-authentication-getting-stuck-on-please-wait-for-local-session-manager?language=en_US

$StartTime=(Get-date).AddDays(3)
$EndTime= ($StartTime).AddDays(3)
$ComputerName =  ""
$eventtime=(Get-WinEvent -computername $ComputerName -FilterHashtable @{LogName='System';StartTime=$StartTime;EndTime=$EndTime; ID=9}).TimeCreated


$FASserver=Get-FasServer|select @{name='name'; expression={$_.Address}} 
$FASserver.name|Foreach-object {
$CitrixFasAddress= "$_"
$fasusercert=get-fasusercertificate -MaximumRecordCount 9999
$fasusercert|select UserPrincipalName, ExpiryDate, @{name='FASServer'; expression={$CitrixFasAddress}} |export-csv "fasUserCert.csv" -append 
}




$StartTime=(Get-date).AddDays(-1)
$EndTime= ($StartTime).AddDays(1)
$StartTime
$EndTime



$userid="trpky17"
$user=Get-aduser -Identity $userid
$userupn=$user.UserPrincipalName
$userupn

### --- in FAS 
$CitrixFasAddress = (Get-FasServerForUser -UserPrincipalNames $userupn).Server
$usercert=Get-FasUserCertificate -UserPrincipalName  $userupn
$usercert.certificate >usercert.crt
certutil -urlfetch -verify usercert.crt > certname.txt
$result= get-content  .\certname.txt
$result |select-string  "failure", "error" ,$userupn

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

