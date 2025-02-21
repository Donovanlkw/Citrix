### --- Export a configuration. 
Export-STFConfiguration -ZipFileName STFconfiguration.zip -targetfolder $env:tmp -NoEncryption

### --- Import a configuration. 
Clear-STFDeployment -Confirm $False
Add-STFDeployment -siteID 1 
Import-STFConfiguration -ConfigurationZip "$env:tmp\STFconfiguration.zip"
