$userid=""
$VDA=""
$ComputerName = Get-Content serverlist.txt
$id =""
$ProviderName =""

$StartTime=(Get-date).AddDays(-1)
$EndTime= ($StartTime).AddDays(1)
$StartTime
$EndTime

### --- Unknown error/warning log.
$ComputerName | Foreach-object {
$unknownSysErr=Get-WinEvent -computername $_ -FilterHashtable @{LogName='System';ProviderName=$ProviderName;StartTime=$StartTime;EndTime=$EndTime;id=$id} |where-object{$_.level -ne 4}|Select-Object -First 100
$unknownAppErr=Get-WinEvent -computername $_ -FilterHashtable @{LogName='Application';ProviderName=$ProviderName;StartTime=$StartTime;EndTime=$EndTime;id=$id} |where-object{$_.level -ne 4}|Select-Object -First 100
$unknownSysErr
$unknownAppErr 
}

$Alllog= $ComputerName | Foreach-object {
Get-WinEvent -computername $_ -FilterHashtable @{LogName='System';ProviderName=$ProviderName;StartTime=$StartTime;EndTime=$EndTime;id=$id} |where-object{$_.level -ne 4}|Select-Object -First 100
Get-WinEvent -computername $_ -FilterHashtable @{LogName='Application';ProviderName=$ProviderName;StartTime=$StartTime;EndTime=$EndTime;id=$id} |where-object{$_.level -ne 4}|Select-Object -First 100
}
$Alllog |select MachineName, LogName, Provide,id,TimeCreated,Message |format-table
$Alllog.message



### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- 
<#
### --- https://docs.citrix.com/en-us/federated-authentication-service/2212/config-manage/troubleshoot-logon.html
### --- 101, https://support.citrix.com/s/article/CTX340100-error-identity-assertion-logon-failed-unrecognized-federated-authentication-service?language=en_US
### --- 102, https://support.citrix.com/s/article/CTX564342-unable-to-start-desktop-with-fas-enabled-and-assert-upn-error-event-102-on-fas-server?language=en_US
### --- 107, https://support.citrix.com/s/article/CTX255423-error-event-id-107-citrixauthenticationidentityassertion-user-loses-access-to-mapped-network-drives-after-they-reconnect-to-disconnected-session?language=en_US
### ---  check VDA list and STF 

$user=Get-aduser -Identity $userid
$userupn=$user.UserPrincipalName
$userupn





$computername| Foreach-object {
Invoke-Command -Computer $_ -ScriptBlock {
Get-ItemProperty -Path "HKLM:SOFTWARE\Policies\Citrix\Authentication\UserCredentialService\Addresses"
}
}


### --- collect all the FAS error/warning log.
$Err=Get-WinEvent -computername $ComputerName -FilterHashtable @{LogName='Application';ProviderName='Citrix.Authentication.IdentityAssertion';StartTime=$StartTime;EndTime=$EndTime} |where-object{$_.level -ne 4}|Select-Object -First 10
$Err
$FASLogin=Get-WinEvent -computername $ComputerName -FilterHashtable @{LogName='Application';StartTime=$StartTime;EndTime=$EndTime;id=106} |Select-Object -First 1
$VDA_FASLogin
$Authtime=($FASLogin).TimeCreated

### --- collect all the FAS error/warning log.
$Comptername | Foreach-object {
$Alllog=Get-WinEvent -computername $_ -FilterHashtable @{LogName='Citrix Delivery Services';StartTime=$StartTime;EndTime=$EndTime}  |where-object{$_.level -ne 4}|Select-Object -First 10
### --- $STF_FASErr|where-object {$_.Message -like "*$userid*"} |Select-Object -First 10
$STF_Err
}

### --- collect all the FAS error/warning log.
$CTXHostSTF.fqdn | Foreach-object {
$STF_Err=Get-WinEvent -computername $_ -FilterHashtable @{LogName='Citrix Delivery Services';StartTime=$StartTime;EndTime=$EndTime}  |where-object{$_.level -ne 4}|Select-Object -First 10
### --- $STF_FASErr|where-object {$_.Message -like "*$userid*"} |Select-Object -First 10
$STF_Err
}

### --- All FAS related error/warning log.
$VDA_FASErr=Get-WinEvent -computername $VDA -FilterHashtable @{LogName='Application';ProviderName='Citrix.Authentication.IdentityAssertion';StartTime=$StartTime;EndTime=$EndTime} |where-object{$_.level -ne 4}|Select-Object -First 10
$VDA_FASErr

### --- AD authentication required time --- ###
$VDA_AuthErr=(Get-WinEvent -computername $VDA -FilterHashtable @{LogName='System';StartTime=$StartTime;EndTime=$EndTime; ID=9}).message
$VDA_AuthErr



### ---  101 check the FAS policy --- ### 
$computername| Foreach-object {
Invoke-Command -Computer $_ -ScriptBlock {
Get-ItemProperty -Path "HKLM:SOFTWARE\Policies\Citrix\Authentication\UserCredentialService\Addresses"
Get-ItemProperty -Path "HKLM:SOFTWARE\WOW6432Node\Policies\Citrix\Authentication\UserCredentialService\Addresses"
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
#>
#----- Collect all log from server group in last n days-----# 

### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- 
#----- Get the RDS Logon in last 7 days-----# 
$StartTime=(Get-date).AddDays(-7)
$EndTime= Get-date
$LogName="Security"
$eventid="4624"
$hostname=$env:computername

$Winevent=Get-WinEvent -ComputerName $hostname -FilterHashTable @{LogName=$LogName;ID=$eventid;StartTime=$StartTime;EndTime=$EndTime} 
$Events =$winevent | ?{$_.Message -match 'logon type:\s+(10)\s'}| ForEach-Object {
    $Values = $_.Properties | ForEach-Object { $_.Value }
    
    # return a new object with the required information
    [PSCustomObject]@{
        Time      = $_.TimeCreated
        # index 0 contains the name of the update
        Event     = $Values[0]
	UserID	= $Values[5]
    }
}

$Events | Format-Table -AutoSize

