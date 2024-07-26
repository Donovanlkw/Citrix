$x=(Get-BrokerCatalog -SessionSupport SingleSession).name

$count= "1"
$MC= "MC"
Get-AcctIdentityPool -IdentityPoolName $MC
Get-BrokerCatalog -name $MC

Get-AcctIdentityPool -IdentityPoolName $MC
Get-BrokerCatalog -name $MC


$newAccounts = New-AcctADAccount -IdentityPoolName $MC -Count $count
$newProvVMtask = New-ProvVM -ADAccountName
$newAccounts.SuccessfulAccounts -ProvisioningSchemeName $MC -RunAsynchronously
$taskDetails = Get-provTask -taskid $newProvVMtask.Guid
$taskDetails.CreatedVirtualMachines | ForEach-Object { 
  if( ! (New-BrokerMachine -MachineName $_.ADAccountSid -CatalogUid (Get-BrokerCatalog -Name $MC).Uid )) {
    "Do some error handling here" 
    } 
}

