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

Get-ConfigRegisteredServiceInstance | Measure

$ComputerName| Foreach-object {
$Compu=$_
$Sitetest=Start-EnvTestTask -TestSuiteId Infrastructure
$Sitetestresult=$Sitetest.Testresults
$SitetestPASS=($Sitetestresult |Where-Object {$_.TestComponentStatus -eq "CompletePassed"}).count
$SitetestFAIL=($Sitetestresult |Where-Object {$_.TestComponentStatus -ne "CompletePassed"}).count

$VMInfo = [pscustomobject]@{
Name = $_
SitetestPASS=$SitetestPASS
SitetestFAIL=$SitetestFAIL
}
# $VMInfo |Format-Table -autosize
$AllResult += $VMInfo
}

$AllResult
