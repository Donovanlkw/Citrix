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

$userid=""
$user=Get-aduser -Identity $userid
$userupn=$user.UserPrincipalName
$CitrixFasAddress = (Get-FasServerForUser -UserPrincipalNames $userupn).Server
Get-FasUserCertificate -UserPrincipalName  $userupn


$FASserver=Get-FasServer|select @{name='name'; expression={$_.Address}} 
$FASserver.name|Foreach-object {
$CitrixFasAddress= "$_"
$fasusercert=get-fasusercertificate -MaximumRecordCount 9999
$fasusercert|select UserPrincipalName, ExpiryDate, @{name='FASServer'; expression={$CitrixFasAddress}} |export-csv "fasUserCert.csv" -append 
}
