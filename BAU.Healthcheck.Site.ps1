$computerName |out-file serverlistDDC.txt

###---- https://support.citrix.com/article/CTX238581 ---####           

$parameters = @{
  ComputerName = Get-Content serverlistDDC.txt
  ScriptBlock = {
    Get-AcctServiceStatus;
    Get-AdminServiceStatus;
    Get-AnalyticsServiceStatus;
    Get-AppLibServiceStatus;
    Get-BrokerServiceStatus;
    Get-ConfigServiceStatus;
    Get-EnvTestServiceStatus;
    Get-HypServiceStatus;
    Get-LogServiceStatus;
    Get-MonitorServiceStatus;
    Get-OrchServiceStatus;
    Get-ProvServiceStatus;
    Get-SfServiceStatus;
    Get-TrustServiceStatus; 
    Get-LogDatastore;
    Get-MonitorDatastore;
    $BrokerDBConnection=Get-BrokerDBConnection
    Test-BrokerDBConnection -DBConnection $BrokerDBConnection 
    $MonitorDBConnection=Get-MonitorDBConnection
    Test-MonitorDBConnection -DBConnection $MonitorDBConnection
    $LogDBConnection=Get-LogDBConnection
    Test-LogDBConnection -DBConnection $LogDBConnection
   }
}
Invoke-Command @parameters |select PSComputerName, DataStore, Status, ServiceStatus, ExtraInfo |Format-table -AutoSize
$ComputerName="AZAWVCTXDCTD01`r`AZAWVCTXDCTD02"
#$ComputerName="AZAWVCTXHDCP02`r`nAZAWVCTXSDCP02`r`nAZJWVCTXDCP02`r`nAZWAPPCTXTDDC02`r`nAZWAPPCTXODDC02"
$computerName |out-file serverlistDDC.txt

###---- https://support.citrix.com/article/CTX238581 ---####           

$parameters = @{
  ComputerName = Get-Content serverlistDDC.txt
  ScriptBlock = {
    Get-AcctServiceStatus;
    Get-AdminServiceStatus;
    Get-AnalyticsServiceStatus;
    Get-AppLibServiceStatus;
    Get-BrokerServiceStatus;
    Get-ConfigServiceStatus;
    Get-EnvTestServiceStatus;
    Get-HypServiceStatus;
    Get-LogServiceStatus;
    Get-MonitorServiceStatus;
    Get-OrchServiceStatus;
    Get-ProvServiceStatus;
    Get-SfServiceStatus;
    Get-TrustServiceStatus; 
    Get-LogDatastore;
    Get-MonitorDatastore;
    $BrokerDBConnection=Get-BrokerDBConnection
    Test-BrokerDBConnection -DBConnection $BrokerDBConnection 
    $MonitorDBConnection=Get-MonitorDBConnection
    Test-MonitorDBConnection -DBConnection $MonitorDBConnection
    $LogDBConnection=Get-LogDBConnection
    Test-LogDBConnection -DBConnection $LogDBConnection
   }
}
Invoke-Command @parameters |select PSComputerName, DataStore, Status, ServiceStatus, ExtraInfo |Format-table -AutoSize



$AllResult = @()
$parameters = @{
  ComputerName = Get-Content serverlistDDC.txt
  ScriptBlock = {
    $x=get-childitem env:computername
    $Sitetest=Start-EnvTestTask -TestSuiteId Infrastructure
    $Sitetestresult=$Sitetest.Testresults
    $SitetestPASS=($Sitetestresult |Where-Object {$_.TestComponentStatus -eq "CompletePassed"}).count
    $SitetestFAIL=($Sitetestresult |Where-Object {$_.TestComponentStatus -ne "CompletePassed"}).count

$VMInfo = [pscustomobject]@{
Name=$x.value
SitetestPASS=$SitetestPASS
SitetestFAIL=$SitetestFAIL
}
#$VMInfo 
$AllResult += $VMInfo

$AllResult|Format-Table -autosize
    }
}

Invoke-Command @parameters 
