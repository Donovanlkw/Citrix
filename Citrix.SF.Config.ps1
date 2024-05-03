

$storeservice = Get-STFStoreService
Get-STFStoreFarm -StoreService $storeservice
Get-STFStoreEnumerationOptions -StoreService $storeservice
Get-STFStoreFarm -StoreService $storeservice
Get-STFStoreFarmConfiguration -StoreService $storeservice
Get-STFStoreGatewayService  -StoreService $storeservice
Get-STFStoreLaunchOptions -StoreService $storeservice
Get-STFStorePna -StoreService $storeservice
Get-STFStorePnaSmartAccess -StoreService $storeservice
Get-STFStoreRegisteredGateway -StoreService $storeservice
Get-STFStoreRegisteredOptimalLaunchGateway -StoreService $storeservice
Get-STFStoreService -StoreService $storeservice
Get-STFStoreSubscriptionsDatabase -StoreService $storeservice



Get-STFDeployment 
Get-STFDomainService
Get-STFFeatureState
Get-STFFeatureStateNames
Get-STFHmacKey
Get-STFInstalledFeatures
Get-STFPackage
Get-STFPeerResolutionService
Get-STFServerGroup
Get-STFServerGroupJoinState
Get-STFServiceMonitor
Get-STFVersion

#Add-STFDeployment
#Add-STFFeatureState
#Add-STFHmacKey
#Clear-STFDeployment
#Clear-STFFeatureStates

#Export-STFConfiguration


#Import-STFConfiguration
#Install-STFFeature
#New-STFFeatureState
#New-STFFeatureStateProperty
#Publish-STFServerGroupConfiguration
#Remove-STFFeatureState
#Remove-STFHmacKey
#Remove-STFServerGroupMember
#Reset-STFFeatureData
#Save-STFService
#Set-STFDeployment
#Set-STFDiagnostics
#Set-STFDomainService
#Set-STFFeatureState
#Set-STFServiceMonitor
#Start-STFServerGroupJoin
#Stop-STFServerGroupJoin
#Uninstall-STFFeature
#Unprotect-STFConfigurationExport
#Update-STFHmacKey
#Wait-STFPublishServerGroupConfiguration
#Wait-STFServerGroupJoin

https://support.citrix.com/article/CTX206009

https://developer-docs.citrix.com/projects/storefront-powershell-sdk/en/latest/Get-STFStoreService/

https://dennisspan.com/translating-the-citrix-storefront-console-to-powershell/

https://github.com/citrix/storefront-powershell-sdk-old/blob/master/docs/storefront-services-authentication-sdk.md

https://www.mycugc.org/blogs/chris-jeucken/2021/03/02/unattended-storefront-install-and-config

