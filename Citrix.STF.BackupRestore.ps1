
### --- Export a configuration. 

Export-STFConfiguration -ZipFileName STFconfiguration.zip -targetfolder $env:tmp -NoEncryption


Get-STFVersion
Get-STFFeatureState
Get-STFFeatureStateNames

Get-STFDomainService
Get-STFPackage
Get-STFInstalledFeatures
Get-STFPeerResolutionService
Get-STFServiceMonitor

### --- Import a configuration. 
Clear-STFDeployment -Confirm $False
Add-STFDeployment -siteID 1 
Import-STFConfiguration -ConfigurationZip "$env:tmp\STFconfiguration.zip"
