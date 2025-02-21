# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
### --- https://docs.citrix.com/en-us/storefront/2203-ltsr/sdk-overview.html

### --- Import a configuration. 
#Clear-STFDeployment -Confirm $False
Add-STFDeployment -siteID 1 
Import-STFConfiguration -ConfigurationZip "$env:tmp\bac.zip"

# # # # # # # # # # # 
### --- Create a server Group
### at Primary server 
Start-STFServerGroupJoin -IsAuthorizingServer -Confirm:$false
Write-Host 'Use the Passcode to join to this server'
$Passcode = (Start-STFServerGroupJoin -IsAuthorizingServer -Confirm:$false).Passcode



### at secondary servers
#Clear-STFDeployment -Confirm $False
Start-STFServerGroupJoin -AuthorizerHostName serverA -Passcode $Passcode -Confirm:$false

get-stfservergroupjoinstate


### operation.
get-stfservergroupjoinstate

Publish-STFServerGroupConfiguration

#Clear-STFDeployment -Confirm $False



### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- 
### --- collect existing SF information. and Export configuration
$STFDeployment=Get-STFDeployment
$STFDomainService=Get-STFDomainService
$STFFeatureState=Get-STFFeatureState
$STFFeatureStateNames=Get-STFFeatureStateNames
$STFHmacKey=Get-STFHmacKey
$STFInstalledFeatures=Get-STFInstalledFeatures
$STFPackage=Get-STFPackage
$STFPeerResolutionService=Get-STFPeerResolutionService
$STFServerGroup=Get-STFServerGroup
$STFServerGroupConfiguration=Get-STFServerGroupConfiguration
$STFServerGroupJoinState=Get-STFServerGroupJoinState
$STFServiceMonitor=Get-STFServiceMonitor
$STFVersion=Get-STFVersion






#https://docs.citrix.com/en-us/storefront/2203-ltsr/sdk-overview.html
#https://docs.citrix.com/en-us/storefront/current-release/install-standard/create-new-deployment.html
#https://docs.citrix.com/en-us/storefront/current-release/install-standard/create-new-deployment.html
https://support.citrix.com/article/CTX206009
https://developer-docs.citrix.com/projects/storefront-powershell-sdk/en/latest/Get-STFStoreService/
https://dennisspan.com/translating-the-citrix-storefront-console-to-powershell/
https://github.com/citrix/storefront-powershell-sdk-old/blob/master/docs/storefront-services-authentication-sdk.md
https://www.mycugc.org/blogs/chris-jeucken/2021/03/02/unattended-storefront-install-and-config
