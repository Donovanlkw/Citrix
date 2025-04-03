$region = "OM"
$count= "1"

### --- Getting MC list  ---  ### 
$MCList=Get-Brokercatalog -name *Provisioning*
$MC=$MClist |Where-Object {$_.name -like "*$region*" -and $_.name -notlike "*11*"} 
$MC.name


### --- Creating Active Directory Machine Accounts

#Get-AcctIdentityPool -IdentityPoolName $MC |select IdentityPoolName,NamingScheme,NamingSchemeType, OU
$IdentityPoolName = Get-AcctIdentityPool -IdentityPoolName $MC.name
$newAccounts = New-AcctADAccount -IdentityPoolName $IdentityPoolName.IdentityPoolName -Count $count
$newAccounts 

### --- Creating Machine  ---  ### 

$Prov=Get-provscheme |where-object {$_.IdentityPoolName -like $IdentityPoolName.IdentityPoolName}
New-provVM -ADAccountName $newAccounts.SuccessfulAccounts -ProvisioningSchemeName  $Prov.ProvisioningSchemeName

New-brokermachine -CatalogUid n -MachineName 



$newAccounts.SuccessfulAccounts | ForEach-Object { 
  if( ! (New-BrokerMachine -MachineName $_.ADAccountSid -CatalogUid (Get-BrokerCatalog -Name $MC).Uid )) {
    "Do some error handling here" 
    } 








$newProvVMtask = New-ProvVM -ADAccountName



$newAccounts = New-AcctADAccount -IdentityPoolName $MC -Count $count
$newProvVMtask = New-ProvVM -ADAccountName
$newAccounts.SuccessfulAccounts -ProvisioningSchemeName $MC -RunAsynchronously
$taskDetails = Get-provTask -taskid $newProvVMtask.Guid
$taskDetails.CreatedVirtualMachines | ForEach-Object { 
  if( ! (New-BrokerMachine -MachineName $_.ADAccountSid -CatalogUid (Get-BrokerCatalog -Name $MC).Uid )) {
    "Do some error handling here" 
    } 
}






Get-Brokermachine -CatalogName $MC -MaxRecordCount 50 |select dnsname
Get-Brokermachine -CatalogName $MC -MaxRecordCount 50 |New-BrokerHostingPowerAction -Action "TurnOn"
Timeout 600
get-brokermachine -Filter "((RegistrationState -eq `"unregistered`") -and (PowerState -eq `"On`") -and(SessionSupport -eq `"SingleSession`"))" -MaxRecordCount 500 | New-BrokerHostingPowerAction -Action "reset"


