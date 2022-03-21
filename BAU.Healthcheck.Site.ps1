$ComputerName=
$computerName |out-file serverlist.txt

$parameters = @{
  ComputerName = Get-Content serverlist.txt
  ScriptBlock = {Get-BrokerController}
}
Invoke-Command @parameters | select DNSName, state, DesktopsRegistered, LicensingGraceState |Format-table -AutoSize

###---- https://support.citrix.com/article/CTX238581 ---####

Get-AcctServiceStatus                                                                                                          
Get-AdminServiceStatus                                                                                                         
Get-AnalyticsServiceStatus                                                                                                     
Get-AppLibServiceStatus                                                                                                        
Get-BrokerServiceStatus                                                                                                        
Get-ConfigServiceStatus                                                                                                        
Get-EnvTestServiceStatus                                                                                                       
Get-HypServiceStatus                                                                                                           
Get-LogServiceStatus                                                                                                           
Get-MonitorServiceStatus                                                                                                       
Get-OrchServiceStatus                                                                                                          
Get-ProvServiceStatus                                                                                                          
Get-SfServiceStatus                                                                                                            
Get-TrustServiceStatus           

Get-ConfigRegisteredServiceInstance | Measure

Get-LogDatastore |select DataStore, ConnectionString, Status
Get-MonitorDatastore |select DataStore, ConnectionString, Status

$BrokerDBConnection=Get-BrokerDBConnection
Test-BrokerDBConnection -DBConnection $BrokerDBConnection 
$MonitorDBConnection=Get-MonitorDBConnection
Test-MonitorDBConnection -DBConnection $MonitorDBConnection
$LogDBConnection=Get-LogDBConnection
Test-LogDBConnection -DBConnection $LogDBConnection


#Test-AcctDBConnection                                                                                                          
#Test-AdminDBConnection                                                                                                         
#Test-AnalyticsDBConnection                                                                                                     
#Test-AppLibDBConnection                                                                                                        
#Test-BrokerDBConnection                                                                                                        
#Test-ConfigDBConnection                                                                                                        
#Test-EnvTestDBConnection                                                                                                       
#Test-HypDBConnection                                                                                                           
#Test-LogDBConnection                                                                                                           
#Test-MonitorDBConnection                                                                                                       
#Test-OrchDBConnection                                                                                                          
#Test-ProvDBConnection                                                                                                          
#Test-SfDBConnection                                                                                                            
#Test-TrustDBConnection                                                                                                          

###---- https://support.citrix.com/article/CTX238581 ---####


