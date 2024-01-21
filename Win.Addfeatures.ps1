##### Definition #####
$BrokerServer = Get-RDServer -Role "RDS-CONNECTION-BROKER"
$NewSessionServer= [System.Net.Dns]::GetHostByName($env:computerName).HostName
$contentID = "CA100003"
$checkSCCM = (Get-WmiObject -Namespace ROOT\CCM\SoftMgmtAgent -Class CCM_ExecutionRequestEx) | ? {$_.ContentID -eq $contentID} | ? {$_.CompletionState -ne "Failure"} | ?{$_.State -eq "Completed" } 
if ($checkSCCM) {$SCCM = "Ready"}

$hcS1 = Get-Service -name RDMS" 
$hcs2 = Get-Service -name "TScPubRPC"
$hcs3 = Get-Service -name "TermService"
$hcs4 = Get-Service -name "Spooler"
$hcs5 = Get-Service -name "Ericom Access Server"

if($hcS1.status -eq "running" -and 
	$hcS2.status -eq "running" -and 
	$hcS3.status -eq "running" -and 
	$hcS4.status -eq "running" -and 
	$hcS5.status -eq "running" -and 
	$SCCM -eq "Ready"){
	Set-RDSessionHost -SessionHost $NewSessionServer -NewConnectionAllowed "Yes" -ConnectionBroker $BrokerServer.server 
}else{ 
     Set-RDSessionHost -SessionHost $NewSessionServer -NewConnectionAllowed "No" -ConnectionBroker $BrokerServer.server 
}
