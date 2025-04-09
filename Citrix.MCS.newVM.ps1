$myCredential = Get-Credential

### --- 
$mapping = @(
[PSCustomObject]@{StagingMC="ABC"; MC="DEF"},
[PSCustomObject]@{StagingMC="ABC"; MC="DEF"}
)

### --- check the VM is not enough --- ### 
$stagingVM=Get-Brokermachine -DesktopGroupName "*Automation Staging - Standard*" -IsAssigned $False 
#$stagingVM=Get-Brokermachine -DesktopGroupName *staging* -IsAssigned $False |Where-Object {$_.Desktopgroupname -eq "Standard" } |select machinename, CatalogName, Desktopgroupname |Group-Object -Property CatalogName, Desktopgroupname
$stagingMC=$stagingVM |Group-Object -Property CatalogName | select Name, count 

$RequireMC=$stagingMC |foreach{
    $count= $_.count
    $DG=$_.name
    if ($count -lt "5"){
    write-output $DG
    }
}
$region = ($mapping| Where-Object { $_.dg -like $RequireMC}).MC

$RequireMC
$region
$count
#$region = "UK"

### --- Getting MC list  ---  ### 
$MCList=Get-Brokercatalog -name *Provisioning*
$MC=$MClist |Where-Object {$_.name -like "*$region*" -and $_.name -notlike "*11*"} 
$MC.name

### --- Creating Active Directory Machine Accounts
#Get-AcctIdentityPool -IdentityPoolName $MC |select IdentityPoolName,NamingScheme,NamingSchemeType, OU
$IdentityPoolName = Get-AcctIdentityPool -IdentityPoolName $MC.name
$newAccounts = New-AcctADAccount -IdentityPoolName $IdentityPoolName.IdentityPoolName -Count $count  -ADUserName  $myCredential.Username -ADPassword $myCredential.Password
#$newAccounts = New-AcctADAccount -IdentityPoolName $IdentityPoolName.IdentityPoolName -Count $count
$newAccounts.SuccessfulAccounts

### --- Creating Machine  ---  ### 
$Prov=Get-provscheme |where-object {$_.IdentityPoolName -like $IdentityPoolName.IdentityPoolName}
New-provVM -ADAccountName $newAccounts.SuccessfulAccounts -ProvisioningSchemeName  $Prov.ProvisioningSchemeName


### --- Add VM to MC  ---  ### 
$newAccounts.SuccessfulAccounts | ForEach-Object { 
  if( ! (New-BrokerMachine -MachineName $_.ADAccountSid -CatalogUid (Get-BrokerCatalog -Name $MC.name).Uid )) {
    "Do some error handling here" 
  } 
}

### --- Power On VM ---  ### 
Get-Brokermachine -CatalogName $MC.name  -MaxRecordCount 10 |New-BrokerHostingPowerAction -Action "TurnOn"
#Get-Brokermachine -CatalogName $MC.name  -MaxRecordCount 10 -Filter "((RegistrationState -eq `"unregistered`") -and (PowerState -eq `"On`") -and(SessionSupport -eq `"SingleSession`"))" |New-BrokerHostingPowerAction -Action "reset"
Get-Brokermachine -CatalogName $MC.name |select dnsname

### --- https://support.citrix.com/s/article/CTX550420-how-to-add-machine-to-existing-machine-catalog-and-delivery-group-using-powershell?language=en_US
